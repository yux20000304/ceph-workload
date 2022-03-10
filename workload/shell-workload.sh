#!/bin/bash

set -x

for k in $( seq 1 100000)
do
    mkdir /mnt/cephfs/aaa${k}
    cd /mnt/cephfs/aaa${k}
    for l in $(seq 1 1000)
    do 
        mkdir bbb${l}
        cd ./bbb${l}
        for j in $(seq 1 100)
        do 
            touch file${j}.txt
        done
        cd ../
    done
    
done