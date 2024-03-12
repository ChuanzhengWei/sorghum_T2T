python ~/software/quarTeT/quartet.py TeloExplorer -i j2055A.polished.fasta -c plant -p j2055

seqtk telo -m TTTAGGG j2055A.polished.fasta > J2055A.seqtk.telo.txt

#the code show telomere
library(RIdeogram)
chr <- read.table("tmp/j2055A.telo.telo.chr.txt", sep = "\t", header = T, stringsAsFactors = F)
label <- read.table("tmp/j2055A.telo.telo.label.txt", sep = "\t", header = T, stringsAsFactors = F)
ideogram(karyotype = chr, label = label, label_type = "marker", output = "j2055A.telo.telo.svg")
convertSVG("j2055A.telo.telo.svg", file = "j2055A.telo.telo", device = "png")