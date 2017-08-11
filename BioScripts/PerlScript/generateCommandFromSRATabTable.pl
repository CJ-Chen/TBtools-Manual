#!/usr/bin/env perl
use strict;
my $usage = "
	perl $0 in.sra.table.tab.xls
Note:
	in.sra.table.tab.xls might be transformet with R/Excel from sra.table.csv down load from NCBI
";
my $sraTable = shift;

my $TRINITI_MAIN = "/tools/trinityrnaseq-Trinity-v2.4.0/Trinity";
my $aspe_MAIN = "~/.aspera/cli/bin/ascp";
my $ascp_sshKey = "~/.aspera/cli/etc/asperaweb_id_dsa.openssh";
my $trimmomaticAdapters = "/tools/Trimmomatic-0.33/adapters/merged_adapted.fa";


die $usage unless -s $sraTable;
open IN,'<',$sraTable or die "Can't read sra table in tab format";
my %maxDataSize;
while(<IN>){
	my ($Run,$ReleaseDate,$LoadDate,$spots,$bases,$spots_with_mates,$avgLength,$size_MB,$AssemblyName,$download_path,$Experiment,$LibraryName,$LibraryStrategy,$LibrarySelection,$LibrarySource,$LibraryLayout,$InsertSize,$InsertDev,$Platform,$Model,$SRAStudy,$BioProject,$Study_Pubmed_id,$ProjectID,$Sample,$BioSample,$SampleType,$TaxID,$ScientificName,$SampleName,$g1k_pop_code,$source,$g1k_analysis_group,$Subject_ID,$Sex,$Disease,$Tumor,$Affection_Status,$Analyte_Type,$Histological_Type,$Body_Site,$CenterName,$Submission,$dbgap_study_accession,$Consent,$RunHash,$ReadHash) = split /\t/,$_;
	if($maxDataSize{$ScientificName}<$size_MB){
		$maxDataSize{$ScientificName} = $size_MB;
	}
}
seek IN,0,0;
my %processedSpe;
while(<IN>){
	my ($Run,$ReleaseDate,$LoadDate,$spots,$bases,$spots_with_mates,$avgLength,$size_MB,$AssemblyName,$download_path,$Experiment,$LibraryName,$LibraryStrategy,$LibrarySelection,$LibrarySource,$LibraryLayout,$InsertSize,$InsertDev,$Platform,$Model,$SRAStudy,$BioProject,$Study_Pubmed_id,$ProjectID,$Sample,$BioSample,$SampleType,$TaxID,$ScientificName,$SampleName,$g1k_pop_code,$source,$g1k_analysis_group,$Subject_ID,$Sex,$Disease,$Tumor,$Affection_Status,$Analyte_Type,$Histological_Type,$Body_Site,$CenterName,$Submission,$dbgap_study_accession,$Consent,$RunHash,$ReadHash) = split /\t/,$_;
	next unless $size_MB>=$maxDataSize{$ScientificName};
	next if $processedSpe{$ScientificName}++;
	# 制备shell文件
	my $prefix1 = substr($Run,0,3);
	my $prefix2 = substr($Run,0,6);
	$ScientificName=~s/[^a-zA-Z]/_/g;
	if($LibraryLayout eq "PAIRED"){
	# 
		print join ";",split /\r?\n/,<<"COMMAND"
echo $Run $ScientificName
$aspe_MAIN -i $ascp_sshKey -T anonftp\@ftp-private.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/$prefix1/$prefix2/$Run/$Run.sra .
fastq-dump --defline-seq '\@\$sn/\$ri' --split-files $Run.sra
/bin/rm $Run.sra
$TRINITI_MAIN --seqType fq --left ${Run}_1.fastq --right ${Run}_2.fastq --CPU 20 --normalize_reads --output $ScientificName.${Run}.trinity --full_cleanup --max_memory 80G --trimmomatic --quality_trimming_params "ILLUMINACLIP:$trimmomaticAdapters:2:30:10 MAXINFO:76:0.8 MINLEN:36"
/bin/rm ${Run}_1.fastq ${Run}_2.fastq
COMMAND
	}else{
	# [ \$?!=0 ] && exit \$?;
		print join ";",split /\r?\n/,<<"COMMAND"
echo $Run $ScientificName
$aspe_MAIN -i $ascp_sshKey -T anonftp\@ftp-private.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/$prefix1/$prefix2/$Run/$Run.sra .
fastq-dump --defline-seq '\@\$sn/\$ri' --split-files $Run.sra
/bin/rm $Run.sra
$TRINITI_MAIN --seqType fq --single ${Run}_1.fastq --CPU 20 --normalize_reads --output $ScientificName.${Run}.trinity --full_cleanup --max_memory 80G --trimmomatic --quality_trimming_params "ILLUMINACLIP:$trimmomaticAdapters:2:30:10 MAXINFO:76:0.8 MINLEN:36"
/bin/rm ${Run}_1.fastq
COMMAND
	}
	print "\n";
}
close IN;


__END__
echo SRR3627997 Litchi_chinensis;~/.aspera/cli/bin/ascp -i ~/.aspera/cli/etc/asperaweb_id_dsa.openssh -T anonftp@ftp-private.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR/SRR362/SRR3627997/SRR3627997.sra .;fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR3627997.sra;/bin/rm SRR3627997.sra;/tools/trinityrnaseq-Trinity-v2.4.0/Trinity --seqType fq --left SRR3627997_1.fastq --right SRR3627997_2.fastq --CPU 20 --normalize_reads --output Litchi_chinensis.SRR3627997.trinity --full_cleanup --max_memory 80G --trimmomatic --quality_trimming_params "ILLUMINACLIP:/tools/Trimmomatic-0.33/adapters/merged_adapted.fa:2:30:10 MAXINFO:76:0.8 MINLEN:36";/bin/rm SRR3627997_1.fastq SRR3627997_2.fastq
