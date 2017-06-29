# TBtools-Manual
Start a project to make a useful and readable manual for TBtools.

### Functions:what TBtools can do?
TBtools, short for **"Tools for Biologist"**, is a Toolset and also a project.  
From the very beginning, I just want to develop a Toolset, which can be useful for my self in Command LIne mode, and for my colleage in Graphics User Interface mode.  
However, some friends saw this work and said TBtools would also be useful to them. So, I post it on web. And consequently, more and more friends send me feature calls and more and more functions were added into TBtools.   
Thus, Tills now(2017/06/29), TBtools *as less* contains functions as bellowed:
##### Under CLI Mode:


##### Under GUI Mode:
* Sequence Toolkits
  + Amazing Fasta **Extractor**
        Transformat Fasta file, make a Fasta-Index and extract Fasta Record in a **very** quick way. 
  + Fasta **Stater**
        Stat a Fasta file, which can generate a summary information (record counts, total Len, N50, GC contents ...) of all Fasta record and a file contain sequence features (simplified ID, length, GC content ...) of each fasta record.
  + Fasta **Extractor**
        Directly extract Fasta record from fasta file, which might be slower than *Amazing Fasta Extractor*... This function will be decrepeted or updated... Recommand use **Amazing Fasta Extractor** instead.
  + Fasta **Subseq**
        Similar to *Fasta Extractor*, however, this function was developed for extract **Sequence Region** of specific Fasta records... This function will ne decrepeted or updated... Recommand Use **Amazing Fasta Extractor** instead.
  + Fasta **Merge and Split**
        Merge several fasta file into one fasta file Or Split one fasta file into several fasta files.
  + Sequence **Manipulator**
  	Tranformat, Reverse, Complement of sequence
  + NCBI **Seq Downloader**
        Batch download Sequnces from NCBI according to GI or Accession Number list.
  + Get Completes **ORF**(Open Reading Frame)
  	Predict complete ORF from input sequence. At present, this function only detect **complete ORF** and only the classic codon usage table. That is, a **complete ORF** here only refer to sequence region starts from *ATG* and ends with *TGA*,*TAA* and *TAG*.
  + Check **Primers**(Simple PCR)
        Directly check the primers sequence location to simply stat the specifity of input primer in the specific sequnce database, such as the transcriptome of one species.
  + GFF/GTF Sequence Extractor
        Extractor Sequences from genome according to gene structure annotation file(.gff/.gtf).
* Blast
  + **Remote** Blast(No Need for Preinstalled Blast)
        Conduct remote blast through NCBI Blast API...This funtion is *not stable* now, because *JRE1.6* doesn't support *SSL protocol* and I do not want to add third party library for this. Will be updated later.
  + Auto **Blast** Several Sequences To a Big File[Commonly Used]
        Invoke Blast *in the environment* to compare several sequences to a big in Fasta format.
  + Auto **Blast** Two Sequence Sets
        Like above.
  + Auto **Blast** Two Sequence Sets -Big File-
        Like above. *This three functions will be merged into one in the feature*.
  + **Blast** Several Seq To FastQ
        Build a blast database from input fastQ file and Blast several Seq onto it.
  + **Reciprocal Blast**
        Conduct reciprocal Blast between two input file in fasta format.
  + **Blast** XML Alignment Shower
        Make a alignment graph of blast result, which can be used to check the coverage of query sequence or subject sequence.
  + **Blast** XML Dotpot
        Make a dot plot graph of blast result.
  + **Blast** Pileup Grapher
        Make a pileup graph of blast result, which is similar to NCBI blast web serveive result page.
  + TransFormat **Blast**.xml to TBtools.table
        TBtools has definded a tab-seperated format to store and descript the blast result. This table contains some useful staticstic info, like **weighted-Cov**.
  + TransFormat **Blast**.xml to Blast Table
        This function just transformat the blast xml file to a tab-delimed file also the same as the default blast+ outfmt-6.
  + **e-GenomeWalkiing or e-Race**
        Use a sequnce to **FISH** ovelapping reads and assemble into a *long* sequence. This function might be useful to conduction Genome-walking on Re-sequencing data or 5'RACE or 3'RACE on RNAsequencing data *in silco*.

* GO and KEGG



### Usage:how to use TBtools?

### FAQs:why TBtools fails?

### Bugs:where to report the bugs and help developing TBtools?

### To Updates:
-[ ] Fasta Extractor
-[ ] Fasta Subseq
-[ ] Fasta Split

### To DO:
-[ ] Seven set and Eight set Venn

