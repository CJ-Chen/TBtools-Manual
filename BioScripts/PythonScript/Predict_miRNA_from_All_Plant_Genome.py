#!/usr/bin/env python3
import argparse
import os
import sys
import subprocess

TBtoolsPath = "/tools/TBtools_JRE1.6.jar"
VARNAPath = "/tools/VARNAv3-93.jar"
genomeFaPath = "/data/data2/XiaLab/allPlantGenome"

def checkPresetFile():

    if not (os.path.exists(TBtoolsPath) and os.path.isfile(TBtoolsPath)):
        print("TBtools.jar is not found as "+TBtoolsPath)
        sys.exit(1)
    if not (os.path.exists(VARNAPath) and os.path.isfile(VARNAPath)):
        print("VARNA.jar is not found as "+VARNAPath)
        sys.exit(1)
    if not (os.path.exists(genomeFaPath) and os.path.isdir(genomeFaPath)):
        print("Genome File Set is not found as "+genomeFaPath)
        sys.exit(1)

checkPresetFile()

parser = argparse.ArgumentParser()

parser.add_argument("--threadNum",type=int,help="Set threadNum to be used",default=10)
parser.add_argument("--ARM",help="Restrict mature miRNA ARM",choices=["BOTH","FIVE","THREE"],default="BOTH")
parser.add_argument("--maxAsy",type=int,help="set maximum asymmetry",default=2)
parser.add_argument("--maxMatureAsy",type=int,help="set maximum Mature asymmetry ",default=2)
parser.add_argument("--maxStarAsy",type=int,help="set maximum STAR asymmetry",default=2)
parser.add_argument("--minMatureAsy",type=int,help="set maximum Mature asymmetry",default=0)
parser.add_argument("--minStarAsy",type=int,help="set maximum STAR asymmetry",default=0)

parser.add_argument("miRNAfa")

args = parser.parse_args()
print(args)

#  if(opt in ("-"))
commands = """
TBtoolsPath=%s
VARNAPath=%s
genomePath=%s
miRNAPaht=%s
threadNum=%s
checkARM=%s # BOTH|FIVE|THREE
maxAsy=%s
maxMatureAsy=%s
maxStarAsy=%s
minMatureAsy=%s
minStarAsy=%s

cp $TBtoolsPath .
cp $VARNAPath .

for file in $genomePath/*.fna;do ln -s $file;done
for genome in `ls *.fna|perl -pe 's/.fna//'`;do
echo $genome
java -cp TBtools_JRE1.6.jar biocjava.bioDoer.miRNA.TargetSoPipe --inMIRfa $miRNAPaht --inGenomeFa $genome.fna --outTable $genome.target --isFragment true  --maxThreadNum $threadNum;
perl -F'\\t' -lane 'next if $seen{"$F[1],$F[2],$F[3],$F[4]"}++;print if length($F[7])==22 and index($F[7],"-")==-1' $genome.target > $genome.target.mod
java -Xmx100G -cp TBtools_JRE1.6.jar biocjava.bioDoer.miRNA.MIRidentifierBasedOnTargetSoResult --inGenomeFile $genome.fna --inTargetSoFile $genome.target.mod --outPredict $genome.predict --outChecklog $genome.check --threadNum $threadNum --checkARM $checkARM --maxAsy $maxAsy --maxMatureAsy $maxMatureAsy --maxStarAsy $maxStarAsy --minMatureAsy $minMatureAsy --minStarAsy $minStarAsy
cat $genome.predict|perl -lane '$start=index($F[-1],$F[2])+1;$end=$start+length($F[2]);$F[0]=~s/[^0-9a-zA-Z]/_/g;$foldSeq =$F[-1];@fold=split /\s/,`echo -n $foldSeq|/usr/local/bin/RNAfold`;$cmd=qq{java -cp VARNAv3-93.jar fr.orsay.lri.varna.applications.VARNAcmd -sequenceDBN "$fold[0]" -structureDBN "$fold[1]" -basesStyle1 "fill=#FF0000,outline=#FF0000,label=#000000,number=#FF0000" -applyBasesStyle1on }.join (q{,},$start..($end-1)).qq{ -o $F[0].$F[2].$F[3].$F[5].$F[6].jpg -border "20x30" -resolution 10};`$cmd`'
done

    """ % (TBtoolsPath,
           VARNAPath,
           genomeFaPath,
           args.miRNAfa,
           args.threadNum,
           args.ARM,
           args.maxAsy,
           args.maxMatureAsy,
           args.maxStarAsy,
           args.minMatureAsy,
           args.minStarAsy
           )
shellscript=open("tmp.sh","w")
shellscript.write(commands)
shellscript.close()

    
    
    