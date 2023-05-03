#!/bin/bash

TARGET="rocksdb"
#TARGET="wiredtiger"

if [ "$TARGET" = "rocksdb" ]
then
	LIBRARY_PATH="/home/$USER/testbed/rocksdb"
	BENCH_PATH="/home/$USER/testbed/forestdb-bench/rocksdb_build/rocksdb_bench"
elif [ "$TARGET" = "wiredtiger" ]
then
	LIBRARY_PATH="/home/$USER/testbed/wiredtiger/build"
	BENCH_PATH="/home/$USER/testbed/forestdb-bench/wt_build/wt_bench"
else
	exit
fi


MNT="/mnt/nvme"
DEV="nvme0n1"

ratio=50

klen=16
vlen=4096

ndocs=10000000
nops=10000000
duration=180

cache_size=10240
bloom_bits=0
batch_dist="uniform"

delete_flag="false"

function do_init() {
	echo "drop cache & sync & sleep"
	sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches '
	sudo sync
	sleep 5

	echo "umount" $MNT
	sudo rm -rf /mnt/nvme/*
	sudo umount $MNT > /dev/null 2>&1

	echo "format" $DEV
	sudo nvme format /dev/$DEV -t 3600000

	echo "mount" $DEV $MNT
	sudo mkfs.ext4 -F /dev/$DEV || exit
	sudo mount /dev/$DEV $MNT || exit
	sudo chown $USER:$USER $MNT || exit
}

do_init

python3 gen_bench_config.py $ndocs $nops $duration $klen $vlen $cache_size $bloom_bits $ratio $batch_dist $delete_flag < config.ini > my.ini
sudo LD_LIBRARY_PATH=$LIBRARY_PATH $BENCH_PATH -f my.ini
