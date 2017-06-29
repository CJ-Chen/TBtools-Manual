# TBtools-Manual
Start a project to make a useful and readable manual for TBtools.

### Functions:what TBtools can do?
TBtools, short for **"Tools for Biologist"**, is a Toolset and also a project.  
From the very beginning, I just want to develop a Toolset, which can be useful for my self in Command LIne mode, and for my colleage in Graphics User Interface mode.  
However, some friends saw this work and said TBtools would also be useful to them. So, I post it on web. And consequently, more and more friends send me feature calls and more and more functions were added into TBtools.   
Thus, Tills now(2017/06/29), TBtools *as less* contains functions as bellowed:
##### In CLI Mode:

To run TBtools in CLI mode,
* if the running environment has *no* graphics device, like under terminal to server, just type `java -jar TBtools_vX.XX.jar`, and then all available tools will be shown. Copy the command for specific tools and use it.
* if the running environment has graphics device, like under windows, mac or X-windows, just type `java -jar TBtools_vX.XX.jar anyString`... If no string after, then TBtools will try to run in GUI mode and in many cases, a TBtools main windows will shown.

**List of Tools under CLI Mode**
will add in the furture...


##### In GUI Mode:
To runu TBtools in GUI mode,
If the .jar file has been linked to java, then just **Double-click the .jar file**. the TBtools main window will show up.   
If user install TBtools from .exe file **under windows**, just run TBtools like many other software.    
If user want to run TBtools in GUI mode with useful debug information, just type `java -jar TBtools_vX.XX.jar debug`.

**List of Tools under GUI Mode**

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
  + **GO** Annotation
        Conduct a gene-ontology annotation. This function is only a ID-mapping tools, which map the input GI,Accession Number of NCBI,Uniprot or Tremble to GO ID.
  + **GO** Enrichment
        Conduct gene-ontology term enrichment analysis basing on hypergeometrix distribution.
  + **GO** Level Counter
        Count gene number at specific GO level, output a statistics table and an optional graph.
  + **GO** Level Compare
        Compare two GO annotation result on specific GO level and output a graph. This function *do not* work well now. Will fix it.
  + **GO** Term Parser
        Parse GO annotation, from which user can know every gene2GO and GO2gene mapping information.
  + Prepare **GO** Annotation for BiNGO in cytoscape
        Transformat *many* gene-ontology annotation into a formated file for BiNGO.
  + **KEGG** Enrichment Analysis
        Conduct KEGG pathway analysis basing on hypergeometrix distribution.
  + **KEGG** Pathwat Map Drawer
        Hightlight genes on KEGG pathway map.
* Other
  + **C**o**l**o**r** **P**i**c**k**e**r
        Pick color code freely and save color code graph as needed.
  + **Table** ID Manipulator
        Extract, Filter or Rank table *Row*
  + **Table** Column Manipulator
        Rank or keep only *Column* selected... Extract or Filter funstion **WILL BE ADDED**.
  + **Big Text** Viewer
        Take a glance of text file with very **Big Size** in a **very quick** way.
  + **Big Table** Viewer
        Take a glance of table file with very **Big Size** in a **very quick** way.
  + **Text Block** Extractor
        Extract Text Block with specific ID list and record seperate string. This function was developed for extracting synteny block.
  + **Expression** Shower
        Visulize expression trend of one gene or several gene.
  + **Expression** Calculator
        Calculate expression value (**RPKM** or **TPM** value) according gene.counts and gene.len
  + **Wonderful Venn** (Up to Six Sets)
        Conduct Venn analysis in an interative way.
  + **Map** Genes On Genome From Sequence Files
        Conduct Blast to get the positon region of input gene on genome and then output a graph
  + **Map** Genes On Genome From Position Info File
        Draw a gene on genome file basing on input gene and genome info.
  + **Dual Synteny Plot** from MCScanX output
        Visulize result from MCScanX in a interactive way.
  + **Domain/Motif** Pattern Drawers
        Visulzie result from MEME suite, NCBI Batch-CD search, pfam-search or GFF/GTF.
* About
  + About TBtools
        Show some information about TBtools.
  + Debug Dialog
        Show Debug dialog, which could be used for bugs tracking.
  + Resize JVM Memory
        Some functions need high memory. So, this function could be used to get a new TBtools Windows wich higher memory. It may be failed under some environment.


### Usage:how to use TBtools?
    A very very long way to go...



### FAQs:why TBtools fails?
    1. Sequence extraction failed.
       Most of the time, if TBtools fail to extract sequences from fasta file, the reason should the *Input ID List* is not match in the *Subject Fasta File*. Test it.
    2. Blast-related Functions failed.
       Thest function has been test for a many many times by many many friends, they should have been statble and robust for quite a long time. If TBtools faided in these function, please check whether the *blast* could be normally run in Command line environment.
    ...
### Bugs:where to report the bugs and help developing TBtools?
    There are many ways to *report bugs* and send *feature calls* for TBtools:
- Send Me an email: ccj0410@gmail.com
- Through QQ chatting group: TBools使用交流群(553679029)
    ...
### To Updates:
- [ ] Fasta Extractor
- [ ] Fasta Subseq
- [ ] Fasta Split

### To DO:
- [ ] Seven set and Eight set Venn

