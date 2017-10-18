##############
#	使用genBlast从所有植物基因组中提取目标基因家族成员
##############
if [ ! -n "$1" ] || [ ! -s $1 ];then
    echo "Please provide a valid query protein set [sh $0 query.pro.fa]"
    exit
fi
# 
# Dicer.fa 为查询的基因家族的 蛋白序列文件 ， fasta格式
#
targetFa=$1
cp -r /tools/genBlast/genBlast_v138_linux_x86_64/* .
for file in /data/data2/XiaLab/allPlantGenome/*.fna;do ln -s $file;done
# 
for genome in *.fna;do
./genblast_v138_linux_x86_64 -p genblastg -q $targetFa -t $genome -e 1e-2 -g T -f F -a 0.5 -d 100000 -r 10 -c 0.5 -s 0 -i 15 -x 20 -n 20 -v 2 -h 0 -j 3 -gff -cdna -pro -o $genome
# 
perl -lane 'next unless $F[2] eq qq{transcript};($chr,$start,$end,$score,$strand,$_)=(@F[0,3,4,5,6],$_);push @pre,[$chr,$start,$end,$score,$strand,$_];END{$count=0;for $cur (sort {$a->[0] cmp $b->[0]||$a->[1]<=>$b->[1]} @pre){if(grep {$cur->[0] eq $_->[0] and $cur->[4] eq $_->[4] and !($_->[1]>$cur->[2]||$_->[2]<$cur->[1])} @{$group{$count}}){push @{$group{$count}},$cur}else{push @{$group{++$count}},$cur}}for $gc (sort keys %group){print join qq{\t},$gc,@{$_} for @{$group{$gc}}}}' ${genome}_1.1c_2.3_s2_tdshift0_tddis0_tcls3.0_m2_score_i0_d16_1.gff > $genome.group.gff
# 
perl -e '$file=shift;$key=shift;$value=shift;open IN,$file;while(<IN>){chomp;@F=split /\t/,$_;$seen{$F[$key]}=$F[$value] if ($seen{$F[$key]}<$F[$value]);}seek IN,0,0;while(<IN>){chomp;@F=split /\t/,$_;print qq{$_\n} if ($F[$value]>=$seen{$F[$key]})}' $genome.group.gff 0 4 > $genome.maxScore.gff
# 
cat $genome.maxScore.gff|perl -lane '($chr,$start,$end,$score,$strand,$ID)=($F[14]=~s/^ID=(.*?);.*$/$1/r,@F[1,2,3,4,5]);print join qq{\t},(($chr,$start,$end,$score,$strand,$ID))' > $genome.ids
# 
perl -lne 'if($switch){if(/^>/){$flag=0;m/^>?(\S+).*?$/;$flag=1 if $need{$1};}print if $flag}else{m/^>?(\S+).*?$/;$need{$1}++}$switch=1 if eof(ARGV)' ${genome}.ids ${genome}_1.1c_2.3_s2_tdshift0_tddis0_tcls3.0_m2_score_i0_d16_1.pro > ${genome}.potential.$targetFa
done