#!/bin/bash

npop=10000000
nops=10000000

klen=16
vlen=4096
sum=`expr $klen + $vlen`

cache_size=8192 # MB
bloom_bits=10

#write_ratio=0
write_ratio=(50 5 0)

distribution=("uniform" "zipfian")


for((i=0; i<=1; i++))
do
	for((j=0; j<=2; j++))
	do
		sudo rm logs/*
		
		OP=${write_ratio[$j]}
		DIST=${distribution[$i]}
		echo $OP $DIST
	
		dir=$DIST"_"$OP"-rocksdb"
		mkdir $dir
	
		./param_eval.sh $npop $nops $klen $vlen $cache_size $bloom_bits $OP $DIST
		sleep 120
	
		sudo cp logs/* $dir
		cp my.ini $dir
	done
done

## YCSB E ##

#sudo rm logs/*
#
#OP=5
#DIST="uniform"
#echo $OP $DIST
#
#dir=$DIST"_"$OP"-scan-rocksdb"
#mkdir $dir
#
#./scan_eval.sh $npop $nops $klen $vlen $cache_size $bloom_bits $OP $DIST
#
#sudo cp logs/* $dir
#cp my.ini $dir

source ~/pushover.sh
push_to_mobile "linux_notification" "driver $dir done! $HOSTNAME @ $(date)"
