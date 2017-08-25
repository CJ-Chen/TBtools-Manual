#!/usr/bin/env python3

import sys
import re
fafile = sys.argv[1]
idfile = sys.argv[2]

# store all ids
idfh = open(idfile,'r')
idSet = set()
for line in idfh:
    idSet.add(line.rstrip())
idfh.close()

pattern = re.compile(">([\w.]+)")
fafh = open(fafile,'r')
hitFlag = False
for line in fafh:
    line = line.strip()
    if line[0] == '>':
        hitFlag = False
        curId = pattern.match(line).group(1)
        if curId not in idSet:
            hitFlag = True
            print (line)
    else:
        if hitFlag:
            print(line)
fafh.close()