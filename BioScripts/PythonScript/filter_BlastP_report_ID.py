#!/usr/bin/env python3
import sys
import re
tabFile = sys.argv[1]

tabfh = open(tabFile,'r')
uniq =set()
for line in tabfh:
    if line[0] == '#':continue
    cols = line.split("\t");
    if float(cols[2])>=50.0 and float(cols[10])<=1e-5:
        uniq.add(cols[1])
tabfh.close()

for curId in uniq:
    print(curId)
