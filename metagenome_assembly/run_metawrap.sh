#!/bin/bash
#SBATCH --partition=cahnrs_bigmem            ### Partition (like a queue in PBS)
#SBATCH --job-name=metawrap_Oral   ### Job Name
#SBATCH --workdir=/data/cornejo/projects/Oral_Microbiome/
#SBATCH --output=metawrap_oral1.out              ### File in which to store job output messages
#SBATCH --error=metawrap_oral1.err               ### File in which to store job error messages
#SBATCH --time=7-00:00:00              ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1                       ### Node count required for the job
#SBATCH --ntasks-per-node=10             ### Nuber of tasks to be launched per Node
#SBATCH --mem=700G                      ### Memory allocated to job
#SBATCH --mail-type=ALL                 ### Email notification: BEGIN,END,FAIL,ALL


module load miniconda3
source activate /opt/apps/conda/envs/metawrap/



#zcat *R1_001.fastq.gz > metawrap/all_reads.1.fastq
#zcat *R2_001.fastq.gz > metawrap/all_reads.2.fastq

metawrap assembly -1 metawrap/all_reads.1.fastq -2 metawrap/all_reads.2.fastq -m 200 -t 96 --metaspades -o metawrap/ASSEMBLY

#nLines=$(wc -l < list )
#for((i=1;i<=$nLines;i++)); do
#        mysample=$(sed -n ''$i'p' list |awk -F "_" '{print $1}')
#        myfile=$(sed -n ''$i'p' list)
