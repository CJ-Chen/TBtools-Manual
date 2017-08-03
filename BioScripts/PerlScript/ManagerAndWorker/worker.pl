#!/usr/bin/env perl
######## 撰写脚本 workder.pl , 主要检测命令列表，逐个执行，无论成功或者失败，每个命令只执行一次，直到获得 成功或者失败的结果 #######
use strict;
use POSIX;
my $year_month_day="[".strftime("%Y-%m-%d %H:%M:%S",localtime())."] ";
my $usage = "
	perl $0 ShellCommandPerLine
";
my $commandList =shift;
die $usage unless -s $commandList;

# 创建一个文件, 表示当前脚本正在运行，不允许两个脚本同时运行
my $flagFile = "TimeJobRunning.CJ.Worker";
if(-e $flagFile){
	print $year_month_day."One Job is already running...\nQuite and wait for next check time...";
	exit;
}else{
	open OUT,'>',$flagFile or die "Can't create RunStatus Checking File\n";
	close OUT;
}
my $finishedCommondFile = "FinishedCommands.txt.CJ.Worker";
my @finishedCommands;
if(-s $finishedCommondFile){
	open ALFINISHED,'<',$finishedCommondFile or die "Can't read input finishedCommondFile\n";
	while(<ALFINISHED>){
		chomp;
		push @finishedCommands,$_;
	}
	close ALFINISHED;
}
my $failCommandFile = "FailCommands.txt.CJ.Worker";
my @failedCommands;
if(-s $failCommandFile){
	open ALFAIL,'<',$failCommandFile or die "Can't read input failCommandFile";
	while(<ALFAIL>){
		chomp;
		push @failedCommands,$_;
	}
	close ALFAIL;
}


open IN,'<',$commandList or die "Can't read input $commandList\n";
my $commandToRun = "";
while(<IN>){
	chomp;
	my $curCommand = $_;
	# 跳过成功了的 ，或者是失败了的
	next if grep {$curCommand eq $_} (@finishedCommands,@failedCommands);
	$commandToRun = $curCommand;
	last;
}
close IN;
if(!$commandToRun){
	print $year_month_day."No Command To Execute...\n";
}else{
	my $ret = system $commandToRun;
	if($ret){
		print $year_month_day."Execute command [$commandToRun] Failed...\n";
		push @failedCommands,$commandToRun;
	}else{
		print $year_month_day."Execute command [$commandToRun] Finished...\n";
		push @finishedCommands,$commandToRun;
	}
	# 将完成的 或者是 失败了的 命令保存
	open FINISHED,'>',$finishedCommondFile or die "Can't write input finishedCommondFile";
	print FINISHED $_,"\n" for @finishedCommands;
	close FINISHED;
	open FAILED,'>',$failCommandFile or die "Can't write into failedCommandsFile";
	print FAILED $_,"\n" for @failedCommands;
	close FAILED;
}
# 删除掉Flag文件
unlink $flagFile;