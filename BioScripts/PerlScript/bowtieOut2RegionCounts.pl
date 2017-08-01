#!/usr/bin/env perl
use strict;
my $usage = "
	perl $0 input.collasped.bowtie.out region.Range region.RPTM
USAGE:
	perl $0 input.collasped.bowtie.out region.Range region.RPTM
	
	region.Range:
		scaffold886:82000-97000
		...
";
my $bowtie = shift;
my $region = shift;
my $rptm = shift;

# my $readMappedTime = shift;

die $usage unless -s $bowtie and -s $region and $rptm;

# my ($scaffold,$start,$end) = map {/(\S+):(\d+)-(\d+)/} $region;
my %region;
open REGION,'<',$region or die "Can't read input region file";
while(<REGION>){
	chomp;
	my ($scaffold,$start,$end) = map {/(\S+):(\d+)-(\d+)/} $_;
	# print ($scaffold,$start,$end);
	push @{$region{$scaffold}},[$start,$end];
}

close REGION;


open BOWTIE,'<',$bowtie or die "Can't read bowtie output file $bowtie\n";
# open OUT,'>',$out or die "Can't write into file:$out\n";

# totalMapped Read Counts
my %seenRead = ();
my $libSize = 0;
my %regionCount;
while(<BOWTIE>){
	# chomp;
	my ($readAndCount,$strand,$curScaffold,$curStart,$readSeq,$readQual,$tallyCount) = split /\t/,$_;
	my ($readId,$readCount) = map {/^(\S+)-(\d+)$/} $readAndCount;
	$libSize += $readCount unless $seenRead{$readAndCount}++;
	
	if($region{$curScaffold}){
	# print ($readAndCount,$strand,$curScaffold,$curStart,$readSeq,$readQual,$tallyCount);
		for(@{$region{$curScaffold}}){
			my ($start,$end) = @{$_};
			
			next if $curStart > $end;
			next if $curStart+length($readSeq) < $start;
			
			push @{$regionCount{"$curScaffold:$start-$end"}},[$readAndCount,$strand,$curScaffold,$curStart,$readSeq,$readQual,$tallyCount];
		}
	}

}
# print STDERR $libSize,"\n";
close BOWTIE;

open RPTM,'>',$rptm or die "Can't write into $rptm file\n";
for (sort keys %regionCount){
	my $region = $_;
	
	my $averageCounts = 0;
	my $totalCounts = 0;
	
	for(@{$regionCount{$_}}){
		my ($readAndCount,$strand,$curScaffold,$curStart,$readSeq,$readQual,$tallyCount) = @{$_};
		my ($readId,$readCount) = map {/^(\S+)-(\d+)$/} $readAndCount;
		# 对于多匹配的结果，直接平均分配
		$totalCounts+=$readCount;
		$averageCounts+=($readCount/$seenRead{$readAndCount});
	}
	# 输出总的计数(包含多匹配)，平均计数（多匹配平均分配），RPTM
	# print $_,"\t",$totalCounts,"\t",$averageCounts,"\t",$averageCounts*10000000/$libSize,"\n";
	
	# 
	print RPTM $_,"\t",$averageCounts*10000000/$libSize,"\n";
}
close RPTM;

__END__
# 
ls *.genome_mapping.txt|parallel -j 40 perl bowtieOut2RegionCount.pl

