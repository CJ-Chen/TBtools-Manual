#!/usr/bin/env python3
import sys
def getGC(inSeq):
    GCcount = 0
    for i in inSeq:
        if i=='G' or i=='C':
            GCcount+=1
    return GCcount/len(inSeq)

seq = "AATGCATCGATCGATGTCGATCAGCTAGCTACGATCAGT"
window_size =5
step_size = 5
is_skip_last = True
GCList = []
kmerList = []
for curPos in range(0,len(seq),step_size):
    curSeq = seq[curPos:curPos+window_size]
    if is_skip_last and len(curSeq)<window_size:
        sys.stderr.write("Warning, skip last kmer because of len...\n")
        continue
    # print(curSeq)
    kmerList.append(curSeq)
    GCList.append(str(getGC(curSeq)))

# for kmerGC in GCList:
#    print(kmerGC)
print(seq)
print("\t".join(kmerList))
print("\t".join(GCList))
