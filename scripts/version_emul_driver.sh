#!/bin/bash

TARGET="rocksdb"

for((i=0; i<=1; i++))
do
	sudo rm logs/*
	dir=$TARGET"-no_version"
	mkdir $dir
	./no_version.sh $TARGET
	sudo cp logs/* $dir
	cp my.ini $dir

	
	sudo rm logs/*
	dir=$TARGET"-version"
	mkdir $dir
	./version.sh $TARGET
	
	sudo cp logs/* $dir
	cp my.ini $dir

	TARGET="wiredtiger"
done
source ~/pushover.sh
push_to_mobile "linux_notification" "driver $dir done! $HOSTNAME @ $(date)"
