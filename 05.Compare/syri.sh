#align with minimap2
minimap2 -ax asm5 -t 64 --eqx J2055A.chr.fasta ref.chr.fasta > J2055A_ref.sam
syri -c J2055A_ref.sam -r J2055A.chr.fasta -q ref.chr.fasta -F S --prefix J2055A_ref

#You can adjust your output using the -s parameter
plotsr --sr J2055A_refsyri.out --genomes genome.txt -H 10 -W 5 -o ref_J2055A.pdf

#Contents of genome.txt
J2055A.chr.fasta	J2055	lc:#66CCFF
ref.chr.fasta	Sbicolor_v3	lc:#FFCC00
