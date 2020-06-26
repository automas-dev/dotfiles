#!/usr/bin/env python3

import sys


def calc_mem(line):
    mem, _ = line.split(None, 1)
    if mem == '0':
        num = 0
    else:
        num = float(mem[:-1])
        sym = mem[-1].upper()
        if sym == 'K':
            num *= 1e3
        elif sym == 'M':
            num *= 1e6
        elif sym == 'G':
            num *= 1e9
        elif sym == 'T':
            num *= 1e12
        elif sym == 'P':
            num *= 1e15
    return num, line.rstrip()


lines = [line for line in sys.stdin]
split = map(calc_mem, lines)
reverse = '--rev' in sys.argv
min_mem = '--mimmem' in sys.argv
sort_lines = sorted(split, key=lambda o: o[0], reverse=reverse)

for size, line in sort_lines:
    if min_mem and size < 1e9:
        continue
    print(line)
