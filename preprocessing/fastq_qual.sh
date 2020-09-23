#!/bin/bash
#SBATCH --partition=popgenom
#SBATCH --output=out_fastQC.txt
#SBATCH --error=error_fastQC.txt
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=crquack@wsu.edu


fastqc --outdir /data/cornejo/projects/cacao_fermentation/1_original_data/fastQC --noextract --nogroup /data/cornejo/projects/cacao_fermentation/1_original_data/*fastq.gz


# Make new directory for the files if it doesn't exist (-p). Text files below will be overwritten if they exist.
mkdir -p fastQC_parse

echo -e "Position\tMean\tFile\tLane" > fastQC_parse/Per_base_sequence_quality.txt
echo -e "Position\tPercent\tBase\tFile\tLane" > fastQC_parse/Per_base_sequence_content.txt
echo -e "GC_Percent\tFragment_Count\tFile\tLane" > fastQC_parse/Per_sequence_GC_content.txt
echo -e "Sequence\tCount\tPercentage\tPossible_Source\tFile" > fastQC_parse/Overrepresented_sequences.txt


# Variable that controls the whole script. By default printing is turned off.
print="No"

# Loop through all fastQC zip files in the bear HiSeq folder. Variable i holds the path to each zip file each iteration through the loop.
# For each file, unzip the raw data (fastqc_data.txt) only and then write the relevant parts to separate files. The unzipped file
# gets written to the temp file (tteemmpp.crq) each iteration through the loop. Note that the file gets overwritten each time and then
# removed at the end. The if statement changes the value of the "print" variable. The case statement determines what information gets
# printed to what file depending on the value stored in the "print" variable.
for i in `ls /data/cornejo/projects/cacao_fermentation/1_original_data/fastQC/*.zip`
do
        file_to_unzip=$(echo $i | awk -F "/" '{print $NF}')
        file_without_extension=${file_to_unzip%.*}
        # Save lane information
        # * in a regex is not like a filename glob. It means 0 or more of the previous character/pattern.
        # . in regex means "any character"
        lane_number=$(echo $file_to_unzip | grep -o "L00.")


        unzip -p $i $file_without_extension"/fastqc_data.txt" > tteemmpp.crq


        while read line
        do
                if [[ ${line:2:10} == "END_MODULE" ]]; then
                        print="No"

                elif [[ ${line:2:25} == "Per base sequence quality" ]]; then
                        print="Per_base_sequence_quality"

                elif [[ ${line:2:25} == "Per base sequence content" ]]; then
                        print="Per_base_sequence_content"

                elif [[ ${line:2:23} == "Per sequence GC content" ]]; then
                        print="Per_sequence_GC_content"

                elif [[ ${line:2:25} == "Overrepresented sequences" ]]; then
                        print="Overrepresented_sequences"
                fi


                case $print in
                        "Per_base_sequence_quality")
                                echo "$line" | awk -v fn="$file_without_extension" -v lane="$lane_number" '{print $1"\t"$2"\t"fn"\t"lane}' >> fastQC_parse/Per_base_sequence_quality.txt
                                ;;
                        "Per_base_sequence_content")
                                echo "$line" | awk -v fn="$file_without_extension" -v lane="$lane_number" '{print $1"\t"$2"\tG\t"fn"\t"lane"\n"\
                                                                                                                  $1"\t"$3"\tA\t"fn"\t"lane"\n"\
                                                                                                                  $1"\t"$4"\tT\t"fn"\t"lane"\n"\
                                                                                                                  $1"\t"$5"\tC\t"fn"\t"lane}' >> fastQC_parse/Per_base_sequence_content.txt
                                ;;
                        "Per_sequence_GC_content")
                                echo -e "${line}\t${file_without_extension}\t${lane_number}" >> fastQC_parse/Per_sequence_GC_content.txt
                                ;;
                        "Overrepresented_sequences")
                                echo -e "$line\t$file_without_extension" >> fastQC_parse/Overrepresented_sequences.txt
                                ;;
                esac
        done < tteemmpp.crq
done

# Remove the temporary file used to parse.
rm tteemmpp.crq

# Remove the unwanted lines from the files (We added our own header above).
sed -i -e '/>>/d' -e '/#/d' fastQC_parse/Per_base_sequence_quality.txt
sed -i -e '/>>/d' -e '/#/d' fastQC_parse/Per_base_sequence_content.txt
sed -i -e '/>>/d' -e '/#/d' fastQC_parse/Per_sequence_GC_content.txt
sed -i -e '/>>/d' -e '/#/d' fastQC_parse/Overrepresented_sequences.txt


mv out_parse.txt fastQC_parse/
mv error_parse.txt fastQC_parse/
