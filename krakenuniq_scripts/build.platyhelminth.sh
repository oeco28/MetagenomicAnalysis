#!/bin/bash
#SBATCH --partition=cahnrs_bigmem
#SBATCH --job-name=build_krakenU_platyhelminth
#SBATCH --output=/data/cornejo/projects/krakenuniq/scripts/logs_kamiak/out/ku_build_platyhelminth
#SBATCH --error=/data/cornejo/projects/krakenuniq/scripts/logs_kamiak/err/ku_build_platyhelminth
#SBATCH --workdir=/data/cornejo/projects/krakenuniq/scripts/
#SBATCH --mem=750G
#SBATCH --time=104:00:00
#SBATCH --ntasks-per-node=20

module load gcc/7.3.0
module load java/oracle_1.8.0_92
module load perl/5.28.0

./krakenuniq-download --db ../../kraken_db_platyhelminth/ --taxa "taxID6157" --dust microbial-nt

jellyfish_bin="/home/omar.cornejo/bin/jellyfish"

./krakenuniq-build --db ../../kraken_db_platyhelminth/ --kmer-len 31 --threads 20 --taxids-for-genomes --taxids-for-sequences --jellyfish-hash-size 10000M
