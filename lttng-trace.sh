#! /bin/bash

work_dir="/home/yyx/project/ceph/build"
filebench_file="/home/yyx/project/ceph-workload/workload/create-workload.f"
reslut_dir="/home/yyx/project/ceph-workload/result"
mount_dir="/mnt/cephfs"

echo 0 > /proc/sys/kernel/randomize_va_space

cd ${work_dir}

#启动一个开启lttng trace的测试集群
../src/vstart.sh -n -l -e -o "osd_tracing = true" --without-dashboard

#建立挂载文件夹
rm -rf ${mount_dir}
mkdir ${mount_dir}

#挂载文件系统
./bin/ceph-fuse -c ./ceph.conf ${mount_dir}

#创建lttng trace-test
lttng create trace-test
lttng enable-event --userspace osd:*
lttng start

#执行工作负载
filebench -f ${filebench_file}

#使用shell指令进行负载测试
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
#             echo "hello world!" > file${j}.txt
#         done
#         cd ../
#     done
#     cd ${dir}
# done
# for k in $( seq 1 10)
# do
#     cd /mnt/cephfs/aaa${k}
#     for l in $(seq 1 10)
#     do 
#         cd ./bbb${l}
#         for j in $(seq 1 10)
#         do 
#             cat file${j}.txt >> ${reslut_dir}/hello.txt
#         done
#         cd ../
#     done
#     cd ${dir}
# done

#暂停lttng并导出信息
lttng stop
lttng view > ${reslut_dir}/osd_trace.json

#导出shell指令测试结果
# lttng view > ${reslut_dir}/osd_trace1.json

lttng destroy

#关闭集群
cd ${work_dir}
../src/stop.sh

#解除挂载
umount ${mount_dir}

#删除文件
rm -rf ${mount_dir}
