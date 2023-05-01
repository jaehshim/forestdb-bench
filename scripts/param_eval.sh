#!/bin/bash

MNT="/mnt/nvme"
DEV="nvme0n1"

ndocs=$1
nops=$2
duration=0

klen=$3
vlen=$4

cache_size=$5
bloom_bits=$6

ratio=$7
batch_dist=$8

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

python3 gen_bench_config.py $ndocs $nops $duration $klen $vlen $cache_size $bloom_bits $ratio $batch_dist < config.ini > my.ini
sudo LD_LIBRARY_PATH=/home/$USER/testbed/rocksdb ./rocksdb_bench -f my.ini
