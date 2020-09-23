#!/bin/bash
#SBATCH --partition=cahnrs_bigmem            ### Partition (like a queue in PBS)
#SBATCH --job-name=metaPhAINfungi   ### Job Name
#SBATCH --workdir=/data/cornejo/projects/Oral_Microbiome/
#SBATCH --output=krakenfungi.out              ### File in which to store job output messages
#SBATCH --error=krakenfungi.err               ### File in which to store job error messages
#SBATCH --time=7-00:00:00              ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1                       ### Node count required for the job
#SBATCH --ntasks-per-node=10             ### Nuber of tasks to be launched per Node
#SBATCH --mem=500G                      ### Memory allocated to job
#SBATCH --mail-type=ALL                 ### Email notification: BEGIN,END,FAIL,ALL


#cd /data/cornejo/projects/sratch_backup/unmapped_cacao/admixed/


source deactivate
unset PYTHONPATH

module load metaphlan2/2.7.8
cd /data/cornejo/projects/Oral_Microbiome

for i in `cat list`; do
        zcat ''$i''_R1_001.fastq.gz ''$i''_R2_001.fastq.gz > $i.comb.fastq
        metaphlan2.py $i.comb.fastq --input_type fastq > meta1/''$i''_profile.txt
done
