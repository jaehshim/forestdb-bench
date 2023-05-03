#!/bin/bash

TARGET=$1

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

ndocs=$2
nops=$3
duration=0

klen=$4
vlen=$5

cache_size=$6
bloom_bits=$7

ratio=$8
batch_dist=$9

delete_flag=$10

function print_param() {
	echo "ndocs, nops:" $ndocs $nops
	echo "klen, vlen:" $klen $vlen
	echo "cache_size:" $cache_size"MB"
	echo "bloom bits per key:" $bloom_bits
	echo "distribution:" $batch_dist
	echo "write ratio:" $ratio"%"
}

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
	sleep 30	

	echo "mount" $DEV $MNT
	sudo mkfs.ext4 -F /dev/$DEV || exit
	sudo mount /dev/$DEV $MNT || exit
	sudo chown $USER:$USER $MNT || exit

	sleep 60
}

print_param

do_init

python3 gen_bench_config.py $ndocs $nops $duration $klen $vlen $cache_size $bloom_bits $ratio $batch_dist $delete_flag < config.ini > my.ini
sudo LD_LIBRARY_PATH=$LIBRARY_PATH $BENCH_PATH -f my.ini
