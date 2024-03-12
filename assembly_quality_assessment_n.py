#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from collections import Counter


# In[ ]:


def FastaToDict(file):
    fasta = {}
    with open(file, 'r')as f:
        lines = f.readlines()
    for line in lines:
        if line[0] == '>':
            key = line.strip()
            fasta[key] = []
        else:
            fasta[key].append(line.strip())
    for key,value in list(fasta.items()):
        fasta[key] = ''.join(value)
    return fasta


# In[ ]:


seq = FastaToDict('Sbicolor_730_v5.0.fa')


# In[ ]:


total_ctg_num = len(list(Counter(seq.keys())))
total_ctg_len = sum(list(map(lambda x: len(x), list(Counter(seq.values())))))
total_ctg_len_half = total_ctg_len * 0.5
sorted_seq = sorted(seq.items(), key=lambda x: len(x[1]), reverse=True)


# In[ ]:


with open('assessment.txt','w')as f:
    f.write(f"total_ctg_num:{total_ctg_num}\n")
    f.write(f"total_ctg_len:{total_ctg_len}\n")
    ctg_sum = 0
    for k,v in sorted_seq:
        ctg_sum += len(v)
        if ctg_sum >= total_ctg_len_half:
            f.write(f"contigN50_chrom:{k.lstrip('>')}\n")
            f.write(f"contigN50_len:{len(v)}\n")
            break
    gc_count = 0
    n_count = 0
    f.write(f"\n\n\n")
    f.write(f"Chrom\tLength\tGC_content\tN_content\tN_count\n")
    for k,v in sorted_seq:
        gc_count_part = v.count('G') + v.count('C')
        gc_content_chr = (v.count('G') + v.count('C')) / (len(v)- v.count('N'))
        n_count_part = v.count('N')
        n_content_chr = v.count('N') / len(v)
        gc_count += gc_count_part
        n_count += n_count_part
        f.write(f"{k.lstrip('>')}\t{len(v)}\t{gc_content_chr}\t{n_content_chr}\t{n_count_part}\n")
    gc_content = gc_count/(total_ctg_len - n_count)
    n_content = n_count/total_ctg_len
    f.write(f"GC_content:{gc_content}\n")
    f.write(f"N_content:{n_content}\n")


# In[ ]:


def pos2region(pos_n_list):
    if not pos_n_list:
        return []
    pos_n_list.sort()
    region_n = []
    start = pos_n_list[0]
    end = start
    for num in pos_n_list[1:]:
        if num == end + 1:
            end = num
        else:
            region_n.append((start, end + 1))
            start = num
            end = start
    region_n.append((start, end + 1))
    return region_n


# In[ ]:


finalbed = []
for k,v in sorted_seq:
    chrom = k.lstrip('>')
    count = 0
    position = []
    for base in v:
        count += 1
        if base == 'N':
            position.append(count)
    bed = [(chrom,l,r) for l,r in pos2region(position)]
    finalbed = finalbed + bed


# In[ ]:


with open('n_position.bed', 'w')as f:
    for c,s,e in finalbed:
        f.write(f"{c}\t{s}\t{e}\n")
with open('n_position_2000.bed', 'w')as f:
    for c,s,e in finalbed:
        f.write(f"{c}\t{s-2001}\t{e+2000}\n")


# In[ ]:


# for k,v in seq.items():
#     distance = 100
#     for i in range(0,len(seq[k]),distance):
#         if i+100 < len(seq[k]):
#             fragment = seq[k][i:i+distance]
#             gc_count = (fragment.count('G') + fragment.count('C')) / len(fragment)
#             print(f"{k.lstrip('>')}\t{i}\t{i+distance}\t{gc_count}")
#         else:
#             fragment = seq[k][i:len(seq[k])]
#             gc_count = (fragment.count('G') + fragment.count('C')) / len(fragment)
#             print(f"{k.lstrip('>')}\t{i}\t{i+distance}\t{gc_count}")

