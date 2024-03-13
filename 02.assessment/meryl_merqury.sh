#meryl
./best_k.sh ${genomesize}
meryl k=19 count output J2055A.hifi.meryl J2055A.hifi.fasta

#merqury.sh
/public/home/weichuanzheng/anaconda3/share/merqury/merqury.sh J2055A.hifi.meryl J2055A.fasta J2055A
