# This is an example for a sample of interest

#!/bin/bash
#SBATCH --partition=cahnrs_bigmem            ### Partition (like a queue in PBS)
#SBATCH --job-name=metaAssmble   ### Job Name
#SBATCH --workdir=/data/cornejo/projects/Oral_Microbiome/
#SBATCH --output=metaSPAdes_test.out              ### File in which to store job output messages
#SBATCH --error=metaSPAdes.test.err               ### File in which to store job error messages
#SBATCH --time=7-00:00:00              ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1                       ### Node count required for the job
#SBATCH --ntasks-per-node=10             ### Nuber of tasks to be launched per Node
#SBATCH --mem=500G                      ### Memory allocated to job
#SBATCH --mail-type=ALL                 ### Email notification: BEGIN,END,FAIL,ALL


#cd /data/cornejo/projects/sratch_backup/unmapped_cacao/admixed/

module load gcc/6.1.0
module load blast/2.9.0

/data/cornejo/projects/programs/SPAdes-3.14.1-Linux/bin/spades.py -1 23_CAGATC_S51_L007_R1_001.fastq.gz -2 23_CAGATC_S51_L007_R2_001.fastq.gz --meta -o metaSPAdes/23.SPAdes.out

blastn -query metaSPAdes/23.SPAdes.out/contigs.fasta -db  /opt/apps/data/blast/nt -out metaSPAdes/23.SPAdes.out/blast.out -outfmt 7
