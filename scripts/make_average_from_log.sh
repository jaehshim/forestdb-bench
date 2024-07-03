#!/usr/bin/env python3
from sys import argv, stdin, stdout, stderr
import re

def main():
	total = [0, 0, 0];
	stat_sum = [0, 0, 0];
	memflush = 0;
	num_memflush = 0;
	for line in stdin:
		line = line.rstrip()
		if "[stat]" not in line:
			continue 
		line = re.split('[],:]', line)
		# print(line[4], line[5])
		if line[4] == ' host flush':
			stat_sum[0] = stat_sum[0] + int(line[5])
			total[0] = total[0] + 1
		elif line[4] == ' host compaction':
			stat_sum[1] = stat_sum[1] + int(line[5])
			total[1] = total[1] + 1
		elif line[4] == ' csd compaction':
			# memflush = memflush + int(line[6])
			# if (int(line[6]) != 0):
			# 	num_memflush = num_memflush + 1
			stat_sum[2] = stat_sum[2] + int(line[5])
			total[2] = total[2] + 1

	# print("%f" % (float)(imm_sum/total), file=stderr)
	# print("%f" % (float)(compact_sum/total), file=stderr)

	print("%.2f" % (float)(stat_sum[0]/total[0]), file=stderr)
	if total[1] != 0:
		print("%.2f" % (float)(stat_sum[1]/total[1]), file=stderr)
	else:
		print("0", file=stderr)
	if total[2] != 0:
		print("%.2f" % (float)(stat_sum[2]/total[2]), file=stderr)
	else:
		print("0", file=stderr)
	# print("%f" % (float)((stat_sum[1] + stat_sum[2])/(total[1] + total[2])), file=stderr)
	print("%.2f" % ((float)(stat_sum[1] + stat_sum[2])/1000/1000), file=stderr)

	print("%d %d %d" % (total[0], total[1], total[2]), file=stderr)

	# if memflush != 0:
	# 	print("%.2f (%d)" % ((float)(memflush/total[2]), num_memflush), file=stderr)



main()
