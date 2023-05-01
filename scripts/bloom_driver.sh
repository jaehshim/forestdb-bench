#!/bin/bash

npop=10000000
nops=10000000

klen=16
vlen=4080
sum=`expr $klen + $vlen`

cache_size=10240 # MB
bloom_bits=10

write_ratio=0

for((i=1; i<=2; i++))
do
	sudo rm logs/*

	dir="bloom_bits_"$bloom_bits
	mkdir $dir

	for((klen=16; klen<=1024; klen*=4))
	do
		vlen=`expr $sum - $klen`
		./param_eval.sh $npop $nops $klen $vlen $cache_size $bloom_bits $write_ratio
		sleep 300
	done
	sudo cp logs/* $dir

	bloom_bits=`expr $bloom_bits + 10`
done

source ~/pushover.sh
push_to_mobile "linux_notification" "driver $dir done! $HOSTNAME @ $(date)"
exit
