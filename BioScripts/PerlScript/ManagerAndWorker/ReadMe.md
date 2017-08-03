## ManagerAndWorkder

#### Why write these ugly scrpts? 

​	Most of the time, the server is free, just like a  idor, wasting our time and money. We should make it working. 

#### How to use these scripts?

1. prepare a command list, in which, one shell comand one line

>echo "Job1"
>
>perl assembly.pl in.fq out.fa
>
>perl align.pl in.fq out.fa out.bam
>
>.....

2. run command like below

```bash
nohup perl manager.pl 'perl worker.pl command.list'
# or I would prefer to run this command under tmux....
```



