define fileset name=testF,entries=10000,filesize=16k,prealloc,path=/mnt/cephfs

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
run 60
