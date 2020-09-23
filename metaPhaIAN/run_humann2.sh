#!/bin/bash
#SBATCH --partition=cahnrs_bigmem
#SBATCH --job-name=denovo_anthu
#SBATCH --output=/data/cornejo/projects/Oral_Microbiome/logs_kamiak/out/out_humann2
#SBATCH --error=/data/cornejo/projects/Oral_Microbiome/logs_kamiak/err/err_humann2
#SBATCH --workdir=/data/cornejo/projects/Oral_Microbiome/
#SBATCH --time=108:00:00
#SBATCH --mem=600G





# zcat 22_TCACAG_S27_L007_R1_001.fastq.gz 22_TCACAG_S27_L007_R2_001.fastq.gz > 22.fastq ; metaphlan2.py 22.fastq  --input_type fastq > meta1/22_profile.txt

source deactivate
unset PYTHONPATH

module load humann2/0.11.2
cd /data/cornejo/projects/Oral_Microbiome

for i in `cat list3`; do
        #zcat ''$i''_R1_001.fastq.gz ''$i''_L007_R2_001.fastq.gz > $i.comb.fastq 
        humann2 --input $i.comb.fastq --output humann2_out/''$i''_fastq
done
