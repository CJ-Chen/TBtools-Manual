# 查看数据
tree .
#
.
├── WT-12h-rep1.fq.gz
├── WT-12h-rep2.fq.gz
├── WT-1h-rep2.fq.gz
├── WT-1h-rep3.fq.gz
├── WT-6h-rep1.fq.gz
└── WT-6h-rep2.fq.gz
# 将fq.gz 转换为 fa文件
# 对数据进行质控
head -n 100000 WT-1h-rep2.fq|perl -lane 'print if $.%4==2'|sort|uniq -c|sort -n|tail|perl -lane 'print qq{>},$count++,qq{_},$F[0],qq{\n},$F[1]'|muscle -clw -quiet
# 
WT-12h-rep1.fq CTGTAGGCAC
WT-12h-rep2.fq CTGTAGGCAC
WT-1h-rep2.fq  CTGTAGGCAC
...
# 人工查看，几乎都一样

ls *.fq|parallel -j 10 'echo -ne {}"\t";head -n 40000 {}|grep -c CTGTAGGCAC'

# WT-12h-rep1.fq  9793
# WT-12h-rep2.fq  9702
# WT-1h-rep2.fq   9809
# WT-1h-rep3.fq   9803
# WT-6h-rep1.fq   9780
# WT-6h-rep2.fq   9799

# head *.fq
# 查看质量值之后发现，都是phred+33的，可以直接转换成fa格式

# 转换成fa
ls *.fq|parallel -j 20 "fastq_to_fasta -v -r -i {} -o {=s/.fq$//=}.fa -Q 33 1>{=s/.fq$//=}.fq2fa.log 2>{=s/.fq$//=}.fq2fa.error"

# 由于接头是一致的，直接去除接头
ls *.fa|parallel -j 20 'fastx_clipper -v -c -l 15 -a "CTGTAGGCAC" -i {} -o {=s/.fa$//=}.trimmed.fa 1>{=s/.fa$//=}.faClip.log 2>{=s/.fa$//=}.faClip.error'
# 只是回帖 fastq文件，所以不需要 collaspe
ls *.trimmed.fa|parallel -j 18 'fastx_collapser -i {} -o {=s/.trimmed.fa//=}.mc.fasta 1>{=s/.trimmed.fa//=}.collapse.log 2>{=s/.trimmed.fa//=}.collapse.error'

