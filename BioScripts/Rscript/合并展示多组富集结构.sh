##########
#	做kegg富集分析
##########

for file in Module*.txt;do
java -cp /C:/Users/CJ/Desktop/TBtools_JRE1.6.jar biocjava.bioDoer.Kegg.AdvancedForEnrichment.KeggEnrichment --inKegRef TBtools.Plant.20180203.KeggBackEnd --Kannotation gene2ko --selectedSet $file --outFile $file.Pathway.EnrichMent.xls
done
# 
perl -F'\t' -lane 'print $F[0] unless $F[5]>0.05 or $F[1]<5 or $seen{$F[0]}++' ModuleGID_*.Pathway.EnrichMent.xls > Show.Term
# 

for file in ModuleGID_*.Pathway.EnrichMent.xls;do
	perl -F'\t' -lane 'print join qq{\t},@F[0,5] if $seen{$F[0]}++' Show.Term $file > $file.selected
done

wc -l *.selected
  23 ModuleGID_cyan.txt.Pathway.EnrichMent.xls.selected
  26 ModuleGID_green.txt.Pathway.EnrichMent.xls.selected
  26 ModuleGID_greenyellow.txt.Pathway.EnrichMent.xls.selected
  25 ModuleGID_lightcyan.txt.Pathway.EnrichMent.xls.selected
 100 total

# 合并表格的时候
perl -e '@AllFile=@ARGV;print qq{GeneID\t};print qq{$_\t} for @AllFile;print qq{\n};while(<ARGV>){chomp;${$ARGV}{(split qq{\t},$_)[0]}=(split qq{\t},$_)[1];$uniqID{(split qq{\t},$_)[0]}++};for $id (keys %uniqID){print qq{$id\t};for(@AllFile){if(${$_}{$id}){print ${$_}{$id}}else{print qq{0}};print qq{\t}};print "\n"}' *.xls.selected|perl -pe 's/\t$//'|perl -pe 's/ModuleGID_(.*?).txt.Pathway.EnrichMent.xls.selected/$1/g' > Merged.Qvalue.txt
