#!/bin/bash

TARGET="leveldb"

LIBRARY_PATH="/home/csl/shim/leveldb-csd/shared_build"
BENCH_PATH="/home/csl/shim/forestdb-bench/build/leveldb_bench"

../../set_cgroup.sh

# MNT="/mnt/nvme"
# DEV="nvme8n1"

ratio=50

klen=16
vlen=4096

ndocs=10000000
nops=2097152
duration=0

cache_size=8196
cache_size=512
bloom_bits=0
batch_dist="uniform"

delete_flag="false"

#csd_offload="true"
csd_offload="false"

function do_init() {
	echo "drop cache & sync & sleep"
	sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches '
	sudo sync
	sleep 5

	# echo "umount" $MNT
	# sudo rm -rf /mnt/nvme/*
	# sudo umount $MNT > /dev/null 2>&1

	# echo "format" $DEV
	# sudo nvme format /dev/$DEV -t 3600000

	# echo "mount" $DEV $MNT
	# sudo mkfs.ext4 -F /dev/$DEV || exit
	# sudo mount /dev/$DEV $MNT || exit
	# sudo chown $USER:$USER $MNT || exit

	pushd /home/csl/shim/leveldb-csd/shared_build
	make -j 20 || exit
	popd

	./load_virt.sh
}

#do_init

make leveldb_bench

#CPU_AFFINITY=0,2,4,6,8,10,12,14,16,18,20
CPU_AFFINITY=0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38

echo "Set CPU AFFINITY" $CPU_AFFINITY
taskset -p -c $CPU_AFFINITY $$ &> /dev/null
sleep 1

python3 gen_bench_config.py $ndocs $nops $duration $klen $vlen $cache_size $bloom_bits $ratio $batch_dist $delete_flag $csd_offload < config.ini > my.ini
#sudo LD_LIBRARY_PATH=$LIBRARY_PATH $BENCH_PATH -f my.ini
sudo LD_LIBRARY_PATH=$LIBRARY_PATH cgexec -g memory:limited_memory_group $BENCH_PATH -f my.ini

cp /mnt/nvme/level/db_run_level0.0/LOG.old load_LOG
cp /mnt/nvme/level/db_run_level0.0/LOG run_LOG
cat run_LOG | ./make_average_from_log.sh

sudo chown -R csl:csl logs


#source ~/shim/pushover.sh
#push_to_mobile "linux_notification" "do_eval $dir done! $HOSTNAME @ $(date)"
