#!/usr/bin/env perl
use strict;
my $usage = "
	perl $0 tableTomerge merged.pos.sorted.info merged.table
Note:
	
";
my $flankingLen = 5;
my $table = shift;
my $info = shift;
my $result = shift;
die $usage unless -s $table && $info && $result;
open TAB,'<',$table or die "Can't read input table\n";
my %posAnno;
while(<TAB>){
	s/\r?\n$//;
	my @cols = split /\t/,$_;
	my $hit = 0;
	my $chr = $cols[0];
	my ($start,$end) = sort {$a<=>$b} (@cols[1,2]);
	if($posAnno{$chr}){
		my @keys = sort keys %{$posAnno{$chr}};
		for (@keys){
			my @curRegion = split /-/,$_;
			if(!($start-$flankingLen>$curRegion[1]||$end+$flankingLen<$curRegion[0])){
				my ($curStart,$curEnd) = (sort {$a<=>$b} ($start,$end,$curRegion[0],$curRegion[1]))[0,-1];
				my @tmpArr = @{$posAnno{$chr}->{$_}};
				# might delete same region...
				delete $posAnno{$chr}->{$_};
				push @{$posAnno{$chr}->{"$curStart-$curEnd"}},(@tmpArr,[@cols]);
				$hit = 1;
				last;
			}
		}
		if(!$hit){
			push @{$posAnno{$chr}->{"$start-$end"}},[@cols];
		}
	}else{
		push @{$posAnno{$chr}->{"$start-$end"}},[@cols];
	}
}
close TAB;
open INFO,'>',$info or die "Can't write into $info\n";
open RESULT,'>',$result or die "Can't write into $result\n";
for my $chr (keys %posAnno){
	for (sort keys %{$posAnno{$chr}}){
		# print $chr,"\t",$_,"\n";
		print INFO "\n";
		my $region = $_;
		print INFO join "\t",$chr,$region,@{$_},+"\n" for @{$posAnno{$chr}->{$_}};
		# 
		my @groupRecord = @{$posAnno{$chr}->{$_}};
		@groupRecord = sort {$a->[4] <=> $b->[4]} @groupRecord;
		print RESULT "\t",@{$groupRecord[-1]};
		print RESULT "\n";
		
	}
}
close INFO;
close RESULT;
