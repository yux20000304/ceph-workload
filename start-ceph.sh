#! /bin/bash

set -x 

work_dir="/home/yyx/project/ceph/build"
filebench_file="/home/yyx/project/ceph-workload/workload/create-workload.f"
reslut_dir="/home/yyx/project/ceph-workload/result"
mount_dir="/mnt/cephfs"


cd ${work_dir}

#启动ceph集群
../src/vstart.sh --new -x --localhost --bluestore

#建立挂载文件夹
rm -rf ${mount_dir}
mkdir ${mount_dir}

#挂载文件系统
./bin/ceph-fuse -c ./ceph.conf ${mount_dir}

#执行工作负载
filebench -f ${filebench_file}
# for k in $( seq 1 10)
# do
#     mkdir /mnt/cephfs/aaa${k}
#     cd /mnt/cephfs/aaa${k}
#     for l in $(seq 1 10)
#     do 
#         mkdir bbb${l}
#         cd ./bbb${l}
#         for j in $(seq 1 10)
#         do 
#             touch file${j}.txt
#         done
#         cd ../
#     done
#     cd ${dir}
# done


#转存osd信息
./bin/ceph daemon osd.0 perf dump > ${reslut_dir}/osd0.json

./bin/ceph daemon osd.1 perf dump > ${reslut_dir}/osd1.json

./bin/ceph daemon osd.2 perf dump > ${reslut_dir}/osd2.json

#转存mon信息
./bin/ceph daemon mon.a perf dump > ${reslut_dir}/mona.json

./bin/ceph daemon mon.b perf dump > ${reslut_dir}/monb.json

./bin/ceph daemon mon.c perf dump > ${reslut_dir}/monc.json

#转存mgr信息
./bin/ceph daemon mgr.x perf dump > ${reslut_dir}/mgrx.json

#转存mds信息
./bin/ceph daemon mds.a perf dump > ${reslut_dir}/mdsa.json

./bin/ceph daemon mds.b perf dump > ${reslut_dir}/mdsb.json

./bin/ceph daemon mds.c perf dump > ${reslut_dir}/mdsc.json

./bin/ceph daemon mds.a perf schema > ${reslut_dir}/mdsa_schema.json

./bin/ceph daemon mds.b perf schema > ${reslut_dir}/mdsb_schema.json

./bin/ceph daemon mds.c perf schema > ${reslut_dir}/mdsc_schema.json


#关闭集群
../src/stop.sh

#解除挂载
umount ${mount_dir}

#删除文件
rm -rf ${mount_dir}
