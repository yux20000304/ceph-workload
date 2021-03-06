define fileset name=testF,entries=1000,filesize=100,prealloc,path=/mnt/cephfs
define fileset name=bigfileset,path=/mnt/cephfs,size=0,leafdirs=50000,dirwidth=5

define process name=dirmake,instances=1
{
  thread name=dirmaker,memsize=1m,instances=16
  {
    flowop makedir name=mkdir1,filesetname=bigfileset
    flowop listdir name=open1,filesetname=bigfileset
  }
}

define process name=readerP,instances=1 {
  thread name=readerT,instances=1 {
    flowop openfile name=openOP,filesetname=testF
    flowop readwholefile name=readOP,filesetname=testF
    flowop writewholefile name=writeOP,filesetname=testF
    flowop closefile name=closeOP
    flowop statfile name=statOP,filesetname=testF
    flowop listdir name=listOP,filesetname=testF
  }
}
run 100
