#!/usr/bin/env python3
from sys import argv, stdin, stdout


def main():
	x = 0

	for line in stdin:
		entry = line.split()

		if len(entry) > 2:
			if entry[0] == "median":
				if x == 1:
					entry[2] = klen
				else:
					entry[2] = vlen

			if entry[0] == "ndocs":
				entry[2] = str(ndocs)

			if entry[0] == "nops":
				entry[2] = str(nops)

			if entry[0] == "duration":
				entry[2] = str(duration)
			
			if entry[0] == "cache_size_MB":
				entry[2] = str(cache_size)

			if entry[0] == "bloom_bits_per_key":
				entry[2] = str(bf_bits)

			if entry[0] == "write_ratio_percent":
				entry[2] = str(ratio)

			if entry[0] == "batch_distribution":
				entry[2] = str(batch)
			
			if entry[0] == "delete":
				entry[2] = str(delete)


		for i in entry:
			print(i,end=" ")
		print("")

		if len(entry) != 0:
			if entry[0] == "[key_length]":
				x = 1
			if entry[0] == "[body_length]":
				x = 2

if len(argv) < 5:
	print("Usage : ./gen_config.py ndocs nops duration klen vlen cache bf_bits write_ratio batch_distribution")
	exit(1)
else:
	ndocs = argv[1]
	nops = argv[2]
	duration = argv[3]
	klen = argv[4]
	vlen = argv[5]
	cache_size = argv[6]
	bf_bits = argv[7]
	ratio = argv[8]
	batch = argv[9]
	delete = argv[10]

	main()
