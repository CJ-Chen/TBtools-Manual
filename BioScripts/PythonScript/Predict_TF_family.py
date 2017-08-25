#!/usr/bin/env python3
"""
#
 input:
    1.AthARF.fa
    2.LcPep.fa.mod-makeblastdb
 ....

 output: tree
"""
import sys
import re
import subprocess

athFamily = sys.argv[1]
targetBlastDb = sys.argv[2] # only BlastP DB prefix

# simplify IDs
fafile = athFamily
blastInFile = fafile+".mod"
faOut = open(blastInFile,'w')
pattern = re.compile("(>[\w.]+)")
fafh = open(fafile,'r')
for line in fafh:
    line = line.strip()
    if line[0] == '>':
        print (pattern.match(line).group(1),file=faOut)
    else:
        print(line,file=faOut)
fafh.close()
faOut.close()
# blastP
blastOutFile = blastInFile+".blastOut"
executeObj = subprocess.Popen("blastp -db "+targetBlastDb+
         " -query "+blastInFile+
         " -outfmt 7 -evalue 1e-5 -num_threads 10 -max_target_seqs 20 -out "+
         blastOutFile,shell=True)
executeObj.wait()
# extractIDs and etract Sequences

### extractIDs
tabFile = blastOutFile
HitsIDOutFile = blastOutFile+".ids"
hitfh = open (HitsIDOutFile,'w')
# print("What?:\t"+tabFile)
tabfh = open(tabFile,'r')
uniq =set()
for line in tabfh:
    if line[0] == '#':continue
    cols = line.split("\t");
    if float(cols[2])>=50.0 and float(cols[10])<=1e-5:
        uniq.add(cols[1])
tabfh.close()

for curId in uniq:
    print(curId,file=hitfh)

hitfh.close()

### extract Seqs:
fafile = targetBlastDb
idfile = HitsIDOutFile
extractSeqOutFile = idfile+".fas"

extractSeqOutFh = open(extractSeqOutFile,"w")
uniqIDs = set()
fh = open (idfile,'r')
for line in fh:
    line = line.rstrip()
    uniqIDs.add(line)      
fh.close()

# print(uniqIDs)
flag = False
# 
fafh = open (fafile,'r')
for line in fafh:
    line = line.rstrip()
    if line[0] == '>':
        flag = False
        if line[1:] in uniqIDs:
            print (line,file=extractSeqOutFh)
            flag = True
    else:
        if flag:
            print(line,file=extractSeqOutFh)

fafh.close()
extractSeqOutFh.close()

# merge Seq
mergeOutFile = extractSeqOutFile+".merged.fa"
executeObj = subprocess.Popen("cat "+extractSeqOutFile+" "+blastInFile+" > "+mergeOutFile,shell=True)
executeObj.wait()
# muscle
# extractSeqOutFile
muscleOutFile = mergeOutFile+".aln"
# print(mergeOutFile)
executeObj = subprocess.Popen("muscle -in "+mergeOutFile+" -out "+muscleOutFile+" -maxiters 1000",shell=True)
executeObj.wait()

# trimal
# print("Now Trimal...")
trimalOutFile = muscleOutFile+".trimal.fa"
executeObj = subprocess.Popen("trimal -in "+muscleOutFile+" -out "+trimalOutFile+" -automated1",shell=True)
executeObj.wait()
# FastTree
treeOut = trimalOutFile+".nwk"
executeObj = subprocess.Popen("FastTree "+trimalOutFile+" > "+treeOut,shell=True)
executeObj.wait()


