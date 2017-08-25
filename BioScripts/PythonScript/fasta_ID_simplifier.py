#!/usr/bin/env python3

import sys
import re
fafile = sys.argv[1]
pattern = re.compile("(>[\w.]+)")
fafh = open(fafile,'r')
for line in fafh:
    line = line.strip()
    if line[0] == '>':
        print (pattern.match(line).group(1))
    else:
        print(line)
fafh.close()