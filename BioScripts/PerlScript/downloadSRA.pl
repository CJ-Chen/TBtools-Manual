use LWP::Simple;

my $usage = "
	perl $0 startDate endDate
Note:
	Download sra.sampleInfo.xml file as specific time region:
	eg.
		perl $0 2017/01/01 2017/12/31
";
my $startDate = shift;
my $endDate  = shift;
die $usage unless $startDate and $endDate;
my $timeStamp = $startDate."_".$endDate;
$timeStamp =~ tr/\//_/;
$query='(("green plants"[Organism]) AND ("biomol rna"[Properties])) AND (("rna seq"[Strategy]) NOT ("mirna seq"[Strategy])) AND (("bgiseq"[Platform]) OR ("illumina"[Platform])) AND ("'.$startDate.'"[Publication Date] : "'.$endDate.'"[Publication Date])';
#assemble the esearch URL
$base = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/';
$url = $base . "esearch.fcgi?db=sra&term=$query&usehistory=y";
# $url=~s/\s+/+/g;
# print "$url\n";
#post the esearch URL
$output = get($url);
# print $output,"\n";
#parse WebEnv, QueryKey and Count (# records retrieved)
$web = $1 if ($output =~ /<WebEnv>(\S+)<\/WebEnv>/);
$key = $1 if ($output =~ /<QueryKey>(\d+)<\/QueryKey>/);
$count = $1 if ($output =~ /<Count>(\d+)<\/Count>/);
#retrieve data in batches of 500
$retmax = 500;
for ($retstart = 0; $retstart < $count; $retstart += $retmax) {
	$efetch_url = $base ."efetch.fcgi?db=sra&WebEnv=$web";
	$efetch_url .= "&query_key=$key&retstart=$retstart";
	$efetch_url .= "&retmax=$retmax&rettype=xml&retmode=full";
	$efetch_out = get($efetch_url);
	open(OUT, ">sra.".$timeStamp.".".$retstart."xml") || die "Can't open file!\n";
	binmode OUT,":utf8";
	print OUT "$efetch_out";
	close OUT;
	# 
	sleep int rand(10)+5;
}
