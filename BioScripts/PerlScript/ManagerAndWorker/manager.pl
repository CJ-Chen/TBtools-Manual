#!/usr/bin/env perl
###################### 再撰写一个脚本 manager.pl 用于监测系统负载 并 调用 worker进行工作 ##################
use strict;
use POSIX;
my $year_month_day="[".strftime("%Y-%m-%d %H:%M:%S",localtime())."] ";
my $usage = "
        perl $0 'Command'
";
my $loadAvgLimit = 2;
my $command =shift;
die $usage unless $loadAvgLimit and $command;

while(1){
	# 查看系统负载
	my @loadAvg=split /\s+/,`cat /proc/loadavg`;
	my $maxLoad = 0;
	for(0..2){
		if($maxLoad<$loadAvg[$_]){
			$maxLoad = $loadAvg[$_];
		}
	}
	if($maxLoad>$loadAvgLimit){
		print $year_month_day."maxLoadAvg is $maxLoad, Higher than given $loadAvgLimit,\nQuit and Wait for Next Check\n";
	}else{
		print $year_month_day."maxLoadAvg is $maxLoad, Ready to Work.\n";
		my @result =`$command`;
		print @result;
		if($result[0] =~/No Command To Execute/){
			print $year_month_day."All Command Were Executed, Quit\n";
			exit;
		}
	}
	# sleep 1000*60*60;
	sleep 2; # 休眠1s
}
