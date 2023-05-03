#!/bin/bash

cd /home/$USER/testbed/forestdb-bench/rocksdb_build
make rocksdb_bench

cd /home/$USER/testbed/forestdb-bench/wt_build
make wt_bench
