#busco
singularity exec /public/home/weichuanzheng/software/singularity/busco/busco.sif busco -i J2055A.fasta -c 32 --miniprot -m genome -l /public/home/weichuanzheng/software/singularity/busco/embryophyta_odb10/ -o J2055A_genome --offline
singularity exec /public/home/weichuanzheng/software/singularity/busco/busco.sif busco -i J2055A.aa.fasta -c 32 --miniprot -m proteins -l /public/home/weichuanzheng/software/singularity/busco/embryophyta_odb10/ -o J2055A_prot --offline
python generate_plot.py -wd /public/home/weichuanzheng/project/16.Btx623/busco/busco-master/scripts/sum

#compleasm
singularity build compleasm.sif docker://huangnengcsu/compleasm:v0.2.5
singularity exec /public/home/weichuanzheng/software/singularity/compleasm/compleasm.sif compleasm run -a J2055A.fasta -o J2055A_genome -l poales -L /public/home/weichuanzheng/software/singularity/compleasm/lineages -t 24
singularity exec /public/home/weichuanzheng/software/singularity/compleasm/compleasm.sif compleasm protein -p J2055A.aa.fasta -o J2055A_prot -l poales -L /public/home/weichuanzheng/software/singularity/compleasm/lineages -t 24
