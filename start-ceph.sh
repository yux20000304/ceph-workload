#! /bin/bash

dir="/home/yyx/project/ceph/build"
cd ${dir}

#启动ceph集群
../src/vstart.sh --new -x --localhost --bluestore

#挂载文件系统
./bin/ceph-fuse -c ./ceph.conf /mnt/cephfs

#执行工作负载
filebench -f /home/yyx/project/workload/ceph-workload.f

#转存osd信息
./bin/ceph daemon osd.0 perf dump > /home/yyx/project/workload/result/osd0.json

./bin/ceph daemon osd.1 perf dump > /home/yyx/project/workload/result/osd1.json

./bin/ceph daemon osd.2 perf dump > /home/yyx/project/workload/result/osd2.json

#转存mon信息
./bin/ceph daemon mon.a perf dump > /home/yyx/project/workload/result/mona.json

./bin/ceph daemon mon.b perf dump > /home/yyx/project/workload/result/monb.json

./bin/ceph daemon mon.c perf dump > /home/yyx/project/workload/result/monc.json

#转存mgr信息
./bin/ceph daemon mgr.x perf dump > /home/yyx/project/workload/result/mgrx.json

#转存mds信息
./bin/ceph daemon mds.a perf dump > /home/yyx/project/workload/result/mdsa.json

./bin/ceph daemon mds.b perf dump > /home/yyx/project/workload/result/mdsb.json

./bin/ceph daemon mds.c perf dump > /home/yyx/project/workload/result/mdsc.json

#关闭集群
../src/stop.sh

#解除挂载
umount /mnt/cephfs

#删除文件
rm -rf /mnt/cephfs/testF