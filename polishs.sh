#polish 'Can be performed multiple times, only displayed once'
#nextpolish
nextPolish run.cfg

#nextPolish2
minimap2 -ax map-hifi -t 64 /public/home/weichuanzheng/project/15.J2055A/11.polish/01_rundir/genome.nextpolish.fasta J2055A.fastq|samtools sort -o hifi.map.sort.bam -
samtools index hifi.map.sort.bam
yak count -o k21.yak -k 21 -b 37 <(zcat sr.R*.fastq.gz) <(zcat sr.R*.fastq.gz)
yak count -o k31.yak -k 31 -b 37 <(zcat sr.R*.fastq.gz) <(zcat sr.R*.fastq.gz) 
yak count -b 37 -t 32 -o k21.yak J2055A.hifi.fasta
yak count -b 37 -t 32 -o k31.yak J2055A.hifi.fasta

nextPolish2 -t 64 hifi.map.sort.bam /public/home/weichuanzheng/project/15.J2055A/11.polish/01_rundir/genome.nextpolish.fasta k21.yak k31.yak > asm.np2.fa
