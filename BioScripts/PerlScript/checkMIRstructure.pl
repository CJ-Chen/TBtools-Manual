#!/usr/bin/env perl
use strict;
use RNA; # Vienna RNA package perl Interface
my $usage = "
	perl $0 possible.percursor.info out
";

my $info = shift;
my $out = shift;
die $usage unless -s $info and $out;
open OUT,'>',$out or die "Can't write into $out";
open INFO,'<',$info or die "Can't read input info file:$info";
while(<INFO>){
	chomp;
	my ($seqId,$percursor,$tag) = split /\t/,$_;
	my $stru_check = &stru_screen($percursor, $tag);
	print OUT $_,"\n" if $stru_check;
}
close INFO;
close OUT;




###########
#	使用夏老师 miRso.pl的一些子函数
############


# define which arm tag reside, return (5p/3p/-)
sub which_arm {
	my $substruct=shift;
	my $arm;
	if ($substruct=~/\(/ && $substruct=~/\)/) {
		$arm="-";
	}
	elsif ($substruct=~/\(/) {
		$arm="5p";
	}
	else {
		$arm="3p";
	}
	return $arm;
}
# compute biggest bulge size
sub biggest_bulge {
	my $struct=shift;
	my $bulge_size=0;
	my $max_bulge=0;
	while ($struct=~/(\.+)/g) {
		$bulge_size=length $1;
		if ($bulge_size > $max_bulge) {
			$max_bulge=$bulge_size;
		}
	}
	return $max_bulge;
}

# compute asymmetry
sub get_asy {
	my($table,$a1,$a2)=@_;
	my ($pre_i,$pre_j);
	my $asymmetry=0;
	foreach my $i ($a1..$a2) {
		if (defined $table->{$i}) {
			my $j=$table->{$i};
			if (defined $pre_i && defined $pre_j) {
				my $diff=($i-$pre_i)+($j-$pre_j);
				$asymmetry += abs($diff);
			}
			$pre_i=$i;
			$pre_j=$j;
		}
	}
	return $asymmetry;
}
sub stru_screen {
    my $MAX_ENERGY = -18;
    my $MIN_SPACE= 5; # minimal space size between miRNA and miRNA*
    my $MAX_SPACE = 200; # maximal space size between miRNA and miRNA*
    my $MIN_PAIR = 14; # minimal pair of miRNA and miRNA*
    my $MAX_BULGE = 4; # maximal bulge of miRNA and miRNA*
    my $MAX_SIZEDIFF = 4; # maximal size different of miRNA and miRNA*
    my $MAX_ASY = 5; # maximal asymmetry of miRNA/miRNA* duplex
    my ($seq, $tag) = @_;
    if ($seq !~ /$tag/) {
        print "$seq => $tag####\n";
    }
    my ($struct,$mfe)=RNA::fold($seq);
    my $tag_beg=index($seq,$tag,0)+1;
    my $tag_end=$tag_beg+length($tag)-1;
    my $tag_length = length $tag;
    my $pass=0;
    if ($mfe > $MAX_ENERGY) {   #fold energy filter;
        return $pass;
    }
    # check for mature;
    my $tag_struct=substr($struct,$tag_beg-1,$tag_length);
    my $tag_arm=which_arm($tag_struct);
    my $tag_unpair=$tag_struct=~tr/.//;
    my $tag_pair=$tag_length-$tag_unpair;
    my $tag_max_bulge=biggest_bulge($tag_struct);
    if ($tag_arm eq "-") {return $pass}   #not a single arm;
    if ($tag_pair < $MIN_PAIR) {return $pass}
    if ($tag_max_bulge > $MAX_BULGE) {return $pass}
    
    # build base pairing table
    my %pairtable;
    &parse_struct($struct,\%pairtable); # coords count from 1
    #print "$seq => $struct => $tag\n";
    # check for star
    my ($star_beg,$star_end)=get_star(\%pairtable,$tag_beg,$tag_end);
    my $star=substr($seq,$star_beg-1,$star_end-$star_beg+1);
    my $star_length=$star_end-$star_beg+1;
    my $star_struct=substr($struct,$star_beg-1,$star_end-$star_beg+1);
    my $star_arm=which_arm($star_struct);
    my $star_unpair=$star_struct=~tr/.//;
    my $star_pair=$star_length-$star_unpair;
    my $star_max_bulge=biggest_bulge($star_struct);
    if ($star_arm eq "-") {return $pass}
    if ($star_pair < $MIN_PAIR) {return $pass}
    if ($star_max_bulge > $MAX_BULGE) {return $pass}

    # space size between miR and miR*
    my $space;
    if ($tag_beg < $star_beg) {
            $space=$star_beg-$tag_end-1;
    }
    else {
            $space=$tag_beg-$star_end-1;
    }
    if ($space < $MIN_SPACE) {return $pass}
    if ($space > $MAX_SPACE) {return $pass}
    
    # size diff
    my $size_diff=abs($tag_length-$star_length);
    if ($size_diff > $MAX_SIZEDIFF) {return $pass}
    
    # asymmetry
    my $asy=get_asy(\%pairtable,$tag_beg,$tag_end);
    if ($asy > $MAX_ASY) {return $pass}
    
    $pass=1;
    return $pass;
}

# build base pair table, coors count from 1
sub parse_struct {
	my $struct=shift;
	my $table=shift;

	my @t=split('',$struct);
	my @lbs; # left brackets
	foreach my $k (0..$#t) {
		if ($t[$k] eq "(") {
			push @lbs, $k+1;
		}
		elsif ($t[$k] eq ")") {
			my $lb=pop @lbs;
			my $rb=$k+1;
			$table->{$lb}=$rb;
			$table->{$rb}=$lb;
		}
	}
	if (@lbs) {
		warn "unbalanced RNA struct.\n";
	}
}
# given a sub-region, get its star region, 2 nt 3' overhang
sub get_star {
	my($table,$beg,$end)=@_;
	
	my ($s1,$e1,$s2,$e2); # s1 pair to s2, e1 pair to e2
	foreach my $i ($beg..$end) {
		if (defined $table->{$i}) {
			my $j=$table->{$i};
			$s1=$i;
			$s2=$j;
			last;
		}
	}
	foreach my $i (reverse ($beg..$end)) {
		if (defined $table->{$i}) {
			my $j=$table->{$i};
			$e1=$i;
			$e2=$j;
			last;
		}
	}
#	print "$s1,$e1 $s2,$e2\n";
	
	# correct terminus
	my $off1=$s1-$beg;
	my $off2=$end-$e1;
	$s2+=$off1;
	$s2+=2; # 081009
	$e2-=$off2;
        $e2=1 if $e2 < 1;
	$e2+=2;
        $e2=1 if $e2 < 1; # 081009
	($s2,$e2)=($e2,$s2) if ($s2 > $e2);
	return ($s2,$e2);
}
