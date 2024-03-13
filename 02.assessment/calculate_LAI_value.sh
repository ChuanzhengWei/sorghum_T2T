#LAI
gt suffixerator -db J2055.fasta -indexname J2055.fasta -tis -suf -lcp -des -ssp -sds -dna
gt ltrharvest -index J2055.fasta -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -motif TGCA -motifmis 1 -similar 85 -vic 10 -seed 20 -seqids yes > J2055.fasta.harvest.scn
LTR_FINDER_parallel -seq J2055.fasta -threads 24 -harvest_out
cat J2055.fasta.harvest.scn J2055.fasta.finder.combine.scn > genome.fa.rawLTR.scn
LTR_retriever -genome J2055.fasta -inharvest genome.fa.rawLTR.scn -threads 24
LAI -genome J2055.fasta -intact J2055.fasta.pass.list -all J2055.fasta.out
