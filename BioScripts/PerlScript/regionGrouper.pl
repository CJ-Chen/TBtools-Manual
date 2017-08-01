#!/usr/bin/env perl
use strict;
my $usage = "
	perl $0 in.table chrColIndex StrandColIndex StartPosIndex EndPosIndex RegionExtendLen
#Note:
In English:
	Read a table and indexes of four columns and an optional extendLen to Group lines, 
	The groupID will be appeded to all lines.
	
	extendLen means to extends length of all records
	
	<===regionStart...regionEnd===>
	
In Chinese:
	输入一个表格，输出结果会在最后一列添加一个GroupID
";
my $table = shift;
my $chrIndex = shift;
my $strandIndex = shift;
my $startPos = shift;
my $endPos = shift;
my $extendRegionLen = shift;
# 
$extendRegionLen = 0 unless defined $extendRegionLen;

die $usage unless -s $table;
open TABLE,'<',$table or die "Can't read input table:$table\n";

my $groupCounts = 0;
my @group = map {chomp;[split /\t/,$_]} <TABLE>;

my $preChr = "";
my $preStrand = "";
my $preStart = 0;
my $preEnd = 0;

my %grouper;

for(sort {
	$a->[$chrIndex] cmp $b->[$chrIndex]
	||
	$a->[$strandIndex] cmp $b->[$strandIndex]
	||
	$a->[$startPos] <=> $b->[$startPos]
	||
	$a->[$endPos] <=> $b->[$endPos]
	} 
	@group){
	# print join ("\t",@{$_}),"\n";
	# my @curCols = @{$_};
	
	my $curChr = $_->[$chrIndex];
	my $curStrand = $_->[$strandIndex];
	my $curStart = $_->[$startPos];
	my $curEnd = $_->[$endPos];

	if($preChr eq $curChr && $preStrand eq $curStrand && $preEnd+$extendRegionLen >= $curStart-$extendRegionLen){
		# already sorted, only need to compare preEnd and curStart 
	}else{
		$groupCounts++;
	}

	$preChr = $curChr;
	$preStrand = $curStrand;
	$preStart = $curStart;
	$preEnd = $curEnd;
	
	# push @{$grouper{$groupCounts}},$_;
	print join ("\t",@{$_},$groupCounts),"\n";
	
}

close TABLE;