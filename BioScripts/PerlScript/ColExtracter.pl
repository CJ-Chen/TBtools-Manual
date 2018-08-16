#!/usr/bin/env perl
use strict;
my $usage = "
	perl $0 matrix.tab id.tab out.tab.xls
";
my $matrix = shift;
my $ids = shift;
my $out = shift;
die $usage unless -s $matrix && -s $ids && $out;
open ID,'<',$ids or die "Can't read id.tab $ids\n";
my %ids;
while(<ID>){
	s/\s*\r?\n$//;
	$ids{$_}=1;
}
close ID;
open MAT,'<',$matrix or die "Can't read matrix.tab $matrix\n";
my $idLine = <MAT>;
$idLine=~s/\s*\r?\n$//;
my @colNames = split /\t/,$idLine;
my @needCols;
my $curIndex =0;
for(@colNames){
	if($ids{$_}){
		push @needCols,$curIndex;
	}
	$curIndex++;
}
# print @needCols;
seek MAT,0,0;
open OUT,'>',$out or die "Can't write into outfile $out\n";
while(<MAT>){
	s/\s*\r?\n$//;
	my @curCols = split /\t/,$_;
	my @printArr;
	for(@needCols){
		push @printArr,$curCols[$_];
	}
	print OUT join "\t",@printArr;
	print OUT "\n";
}
close MAT;
close OUT;