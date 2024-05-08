# sorghum_T2T
The codes to assemble two sorghum cultivars.

## How to download genome files and gene structure annotation files?
Due to the strict restrictions on the gff3 file format by the National Genomics Data Center, I was unable to succeed despite my efforts, so I have hosted the data on Figshare.
https://figshare.com/articles/dataset/Sorghum_genome/25764612

Regarding the BTx623 gff3 file, after our gene structure annotation pipeline, 
I utilized the collinearity among genomic sequences to add structural models of genes that we had not discovered but were annotated in BTx623-v3 and BTx623-v5 (completed by **Liftoff**), 
and subsequently, I performed two rounds of updates using **PASA**.

This version of the gff3 file includes more gene models than either BTx623-v3 or BTx623-v5. I will keep refining this annotation file and update it in a timely manner.
I continue to see potential for optimization in this annotation, particularly concerning the length issues of UTRs, and I strongly suggest further validation with RNA-seq data before related analyses.

Should you wish to learn more about optimizing annotation details, or if any issues arise during use, feel free to contact me at weichuanzheng1202@163.com at any time.
