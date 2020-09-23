#!/bin/bash
#SBATCH --partition=cahnrs_bigmem
#SBATCH --job-name=build_krakenU_bact
#SBATCH --output=/data/cornejo/projects/krakenuniq/scripts/logs_kamiak/out/ku_build_bact2
#SBATCH --error=/data/cornejo/projects/krakenuniq/scripts/logs_kamiak/err/ku_build_bact2
#SBATCH --workdir=/data/cornejo/projects/krakenuniq/scripts/
#SBATCH --mem=750G
#SBATCH --time=104:00:00
#SBATCH --ntasks-per-node=20

module load gcc/7.3.0
module load java/oracle_1.8.0_92
module load perl/5.28.0

mkdir ../../kraken_db_bacteria2
mkdir ../../kraken_db_archaea
mkdir ../../kraken_db_virus

./krakenuniq-download --db ../../kraken_db_bacteria2/ --taxa "bacteria" --dust microbial-nt
./krakenuniq-download --db ../../kraken_db_archaea/ --taxa "archaea" --dust microbial-nt
./krakenuniq-download --db ../../kraken_db_virus/ --taxa "viral" --dust microbial-nt

jellyfish_bin="/home/omar.cornejo/bin/jellyfish"

./krakenuniq-build --db ../../kraken_db_bacteria2/ --kmer-len 31 --threads 20 --taxids-for-genomes --taxids-for-sequences --jellyfish-hash-size 10000M
./krakenuniq-build --db ../../kraken_db_archaea/ --kmer-len 31 --threads 20 --taxids-for-genomes --taxids-for-sequences --jellyfish-hash-size 10000M
./krakenuniq-build --db ../../kraken_db_virus/ --kmer-len 31 --threads 20 --taxids-for-genomes --taxids-for-sequences --jellyfish-hash-size 10000M
