python ~/software/quarTeT-1.16/quartet.py CentroMiner -i j2055A.polished.fasta -t 32

makeblastdb -in j2055A.polished.fasta -dbtype nucl -parse_seqids
blastn -query centromere_motif.fasta -out centromere.blast.txt -db j2055A.polished.fasta -outfmt 6 -evalue 1e-5 -task megablast -max_hsps 5000 -max_target_seqs 10000000 -num_threads 24

#python script to find centromere with blast result
blast_info = []
with open('centromere.blast.txt', 'r')as f:
    lines = f.readlines()
for line in lines:
    line = line.split()
    blast_info += [(line[0], line[1], line[2], line[3], line[8], line[9])]
blast_info_fil = []
for qseqid,sseqid,pident,nident,sstart,send in blast_info:
    if  'pSau3A10' in qseqid and float(nident) >= 250:
#     if float(nident) >= 250:
        blast_info_fil += [(qseqid,sseqid,float(pident),int(nident),int(sstart),int(send))]
chrom = Counter(i[1] for i in blast_info_fil)
with open('r_motif_region.txt', 'w')as f:
    for c in sorted(chrom.keys()):
        chrom_info = [i for i in blast_info_fil if i[1] == c]
        for qseqid,sseqid,pident,nident,sstart,send in chrom_info:
            f.write(f"{sseqid}\t{sstart}\t{send}\n")

def plot_scatter(data):
    df = pd.DataFrame(data, columns=['Value'])
    df['Index'] = range(1, len(df) + 1)
    plt.figure(figsize=(10, 6))
    plt.scatter(df['Index'], df['Value'], color='blue')
    plt.xlabel('Index')
    plt.ylabel('Values')
    plt.show()

for c in sorted(chrom.keys()):
    chrom_info = [i for i in blast_info_fil if i[1] == c]
    target = []
    for qseqid,sseqid,pident,nident,sstart,send in chrom_info:
        target.append(sstart)
        target.append(send)
    target = sorted(target)
    left = target[0]
    right = target[-1]
    print(f"{c} {left} {right}")
    # print(target[:10])
    # print(target[-10:])
    plot_scatter(target)
