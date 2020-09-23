#!/bin/bash
#SBATCH --partition=popgenom            ### Partition (like a queue in PBS)
#SBATCH --job-name=mergedata		    ### Job Name
#SBATCH --workdir=/data/cornejo/projects/../krakenoutput
#SBATCH --output=/data/cornejo/projects/../krakenoutput/mergeku.out              ### File in which to store job output messages
#SBATCH --error=/data/cornejo/projects/../krakenoutput/mergeku.err               ### File in which to store job error messages
#SBATCH --time=10:00:00              ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1                       ### Node count required for the job
#SBATCH --ntasks-per-node=1             ### Nuber of tasks to be launched per Node
#SBATCH --mail-type=ALL                 ### Email notification: BEGIN,END,FAIL,ALL

for i in $(cat list);
do
       cat Fungi/FungiREPORT$i.tsv | awk 'NR >= 4 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}{OFS == “}”}' Fungi/FungiREPORT$i.tsv > Combined/Fungi$iTaxon
       cat Insecta/InsectaREPORT$i.tsv | awk 'NR >= 5 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}{OFS == “}”}' Insecta/InsectaREPORT$i.tsv > Combined/Insecta$iTaxon
       cat Nema/NemaREPORT$i.tsv | awk 'NR >= 5 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}{OFS == “}”}' Nema/NemaREPORT$i.tsv > Combined/Nema$iTaxon
       cat Platy/PlatyREPORT$i.tsv | awk 'NR >= 5 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}{OFS == “}”}' Platy/PlatyREPORT$i.tsv > Combined/Platy$iTaxon
       cat Bacteria/BacteriaREPORT$i.tsv | awk 'NR >= 5 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}{OFS == “}”}' Bacteria/BacteriaREPORT$i.tsv > Combined/Bacteria$iTaxon
       cat Virus/VirusREPORT$i.tsv | awk 'NR >= 5 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}{OFS == “}”}' Virus/VirusREPORT$i.tsv > Combined/Virus$iTaxon
       #cat Combined/Fungi$iTaxon Combined/Insecta$iTaxon Combined/Nema$iTaxon Combined/Platy$iTaxon > Combined/$iTaxon
       #cat Combined/$iTaxon | awk 'NR >= 2 {print $1"\011"$2"\011"$3"\011"$4"\011"$5"\011"$6"\011"$7"\011"$8"\011"$9, $10, $11, $12}{OFS == “}”}' Combined/$iTaxon | sort -nrk2 > Combined/$iTaxon2
       #cat Combined/$iTaxon | awk 'NR == 4 {print $1"\011"$2"\011"$3"\011"$4"\011"$5"\011"$6"\011"$7"\011"$8"\011"$9, $10, $11, $12}{OFS == “}”}' > Combined/$iTaxonColumns
       #cat Combined/$iTaxonColumns Combined/$iTaxon2 > Combined/$i.tsv
done
