#Genome assemble with hifiasm
#hifiasm
#use hifi reads
hifiasm -o J2055A.hifi -t 64 J2055A.hifi.fastq.gz
awk '/^S/{print ">"$2;print $3}' J2055A.hifi.bp.p_ctg.gfa > J2055A.hifi.p_ctg.fa
#use hifi,ont and hic reads
hifiasm -o J2055A -t 64 --ul ONT.fq.gz --h1 J2055A_S545_R1.fastq.gz --h2 J2055A_S545_R2.fastq.gz J2055A.hifi.fastq.gz
awk '/^S/{print ">"$2;print $3}' J2055A.bp.p_ctg.gfa > J2055A.p_ctg.fa

#verkko
verkko -d ./ --hifi J2055A.hifi.fastq.gz --nano ONT.50k.fq.gz --hic1 J2055A_S579_clean.R1.fastq.gz --hic2 J2055A_S579_clean.R2.fastq.gz

#nextdenovo
#needed files: run.cfg and input.fofn
nextDenovo run.cfg


#3ddna
cd references
bwa index J2055A.hifi.p_ctg.fa
python /public/home/weichuanzheng/software/hic/juicer-1.6/misc/generate_site_positions.py MboI genome J2055A.hifi.p_ctg.fa
awk 'BEGIN{OFS="\t"}{print $1, $NF}' genome_MboI.txt > genome.chrom.sizes
cp genome_MboI.txt /public/home/weichuanzheng/project/15.J2055A/08.hic/restriction_sites
cp genome.chrom.sizes /public/home/weichuanzheng/project/15.J2055A/08.hic/restriction_sites
/public/home/weichuanzheng/software/hic/juicer-1.6/CPU/juicer.sh -D /public/home/weichuanzheng/project/15.J2055A/08.hic \
-p /public/home/weichuanzheng/project/15.J2055A/08.hic/restriction_sites/genome.chrom.sizes \
-y /public/home/weichuanzheng/project/15.J2055A/08.hic/restriction_sites/genome_MboI.txt \
-z /public/home/weichuanzheng/project/15.J2055A/08.hic/references/J2055A.hifi.p_ctg.fa \
-s MboI \
-t 32
run-asm-pipeline.sh -r 0 J2055A.hifi.p_ctg.fa merged_nodups.txt
run-asm-pipeline-post-review.sh \
    --sort-output \
    -r asm.hion.rawchrom.review.assembly J2055A.hifi.p_ctg.fa merged_nodups.txt


#allhic
bwa index -a bwtsw J2055A.hifi.p_ctg.fa
samtools faidx J2055A.hifi.p_ctg.fa
bwa aln -t 128 J2055A.hifi.p_ctg.fa J2055A_S545_R1.fastq.gz > sample_R1.sai
bwa aln -t 128 J2055A.hifi.p_ctg.fa J2055A_S545_R2.fastq.gz > sample_R2.sai
bwa sampe J2055A.hifi.p_ctg.fa sample_R1.sai sample_R2.sai J2055A_S545_R1.fastq.gz J2055A_S545_R2.fastq.gz > sample.bwa_aln.sam
perl /public/home/weichuanzheng/software/ALLHiC-master/scripts/PreprocessSAMs.pl sample.bwa_aln.sam J2055A.hifi.p_ctg.fa MBOI
perl /public/home/weichuanzheng/software/ALLHiC-master/scripts/filterBAM_forHiC.pl sample.bwa_aln.REduced.paired_only.bam sample.clean.sam
samtools view -bt J2055A.hifi.p_ctg.fa.fai sample.clean.sam > sample.clean.bam
ALLHiC_partition -b sample.clean.bam -r J2055A.hifi.p_ctg.fa -e GATC -k 10
allhic extract sample.clean.bam J2055A.hifi.p_ctg.fa --RE GATC
allhic optimize sample.clean.counts_GATC.10g1.txt sample.clean.clm #1-10
ALLHiC_plot -b sample.clean.bam -a groups.agp -l chrn.list -s 50k -o heatmap-pdf_50k

#quickly visualize tools for collinearity between two genomes
#NGenomeSyn (use nucmer to align)
perl GetTwoGenomeSyn.pl -NumThreads 48 -InGenomeA j2055a.v3.fasta -InGenomeB Sbicolor_313_v3.0.fa -OutPrefix v3_ref -BinDir /public/home/weichuanzheng/software/mummer/bin

#Raw reads mapping and depth statistics
minimap2 -t 96 -a j1055a.v3.fasta J2055A.fastq > hifi.sam
samtools view -@ 64 -bS hifi.sam | samtools sort -@ 64 - -o hifi.bam
samtools index hifi.bam
rm hifi.sam
pandepth -i hifi.bam -w 500 -t 36 -o hifi_500
pandepth -i hifi.bam -w 1000 -t 36 -o hifi_1000
pandepth -i hifi.bam -w 1 -t 36 -o hifi_1
samtools flagstat -@ 32 hifi.bam > hifi.stat
