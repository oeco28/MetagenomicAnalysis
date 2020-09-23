#!/bin/bash
#SBATCH --partition=cahnrs_bigmem            ### Partition (like a queue in PBS)
#SBATCH --job-name=KrakenUniqBacteria   ### Job Name
#SBATCH --workdir=/data/cornejo/projects/Oral_Microbiome/
#SBATCH --output=krakenBacteria2.out              ### File in which to store job output messages
#SBATCH --error=krakenBacteria2.err               ### File in which to store job error messages
#SBATCH --time=7-00:00:00              ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1                       ### Node count required for the job
#SBATCH --ntasks-per-node=10             ### Nuber of tasks to be launched per Node
#SBATCH --mem=500G                      ### Memory allocated to job
#SBATCH --mail-type=ALL                 ### Email notification: BEGIN,END,FAIL,ALL


#cd /data/cornejo/projects/sratch_backup/unmapped_cacao/admixed/

module load gcc/6.1.0

krakenuniq --db /data/cornejo/projects/kraken_db_bacteria2/ --preload --threads 9
krakenuniq --db /data/cornejo/projects/kraken_db_archaea/ --preload --threads 9
krakenuniq --db /data/cornejo/projects/kraken_db_virus/ --preload --threads 9

mkdir krakenoutput/Bacteria
mkdir krakenoutput/Archaea
mkdir krakenoutput/Virus


nLines=$(wc -l < list )
for((i=1;i<=$nLines;i++)); do
        mysample=$(sed -n ''$i'p' list |awk -F "_" '{print $1}')
        myfile=$(sed -n ''$i'p' list)

        krakenuniq --db /data/cornejo/projects/kraken_db_bacteria2/ --threads 9 --report-file ./krakenoutput/Bacteria/BacteriaREPORT$mysample.tsv --paired --fastq-input --gzip-compressed ''$myfile''_R1_001.fastq.gz ''$myfile''_R2_001.fastq.gz --output ./krakenoutput/Bacteria/Bacteria.$mysample.tsv

        krakenuniq --db /data/cornejo/projects/kraken_db_archaea/ --threads 9 --report-file ./krakenoutput/Archaea/ArchaeaREPORT$mysample.tsv --paired --fastq-input --gzip-compressed ''$myfile''_R1_001.fastq.gz ''$myfile''_R2_001.fastq.gz --output ./krakenoutput/Archaea/Archaea.$mysample.tsv

        krakenuniq --db /data/cornejo/projects/kraken_db_virus/ --threads 9 --report-file ./krakenoutput/Virus/VirusREPORT$mysample.tsv --paired --fastq-input --gzip-compressed ''$myfile''_R1_001.fastq.gz ''$myfile''_R2_001.fastq.gz --output ./krakenoutput/Virus/Virus.$mysample.tsv

done
