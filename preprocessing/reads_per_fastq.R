# Save filename argument passed to the R script from the Reads_Per_Fastq_4.sh script.
args       <- commandArgs(TRUE)
input_file <- args[[1]]

####################### Getting the data ready #######################

# Counting the number of lines in the file, then subtract 2 form it (header line and total reads line). Resulting number is 
# the number of lines to import from the csv file into R.
lines_to_import <- length(readLines(input_file)) - 2


# Read table into R using variable created above to cut off the "total reads" row.
fastq_data <- read.csv(input_file, sep = ",", header = TRUE, nrows = lines_to_import)

###### Parse the sample ID off of the filename and get rid of the rest of the information. Table is now ready to plot.
# Not sure if going to use this because have to install package on Kamiak
# library(splitstackshape)
# fastq_data <- cSplit(fastq_data, "File_Name", "_", type.convert = FALSE)
# fastq_data <- fastq_data[,2:1]
# colnames(fastq_data) <- c("File_Name", "number_of_reads")


# Not as clean as above but dont have to install package on Kamiak
tempTable                  <- data.frame(do.call("rbind", strsplit(as.character(fastq_data$File_Name), "_")), stringsAsFactors = FALSE)
fastq_data                 <- data.frame(cbind(tempTable[,1], fastq_data[,2]), stringsAsFactors = FALSE)
colnames(fastq_data)       <- c("File_Name", "number_of_reads")
fastq_data$number_of_reads <- as.numeric(fastq_data$number_of_reads)
fastq_data$File_Name       <- factor(fastq_data$File_Name, levels = fastq_data$File_Name[order(fastq_data$number_of_reads, decreasing = TRUE)])

rm(tempTable)


# Calculate percent that each library made up of the total pool.
total_reads      <- sum(fastq_data$number_of_reads)
percent_of_total <- round((fastq_data$number_of_reads/total_reads)*100, 2)
fastq_data       <- cbind(fastq_data, percent_of_total)

rm(percent_of_total, total_reads)


# Calculate percentage for perfect pool.
perfect_pool <- round((1/lines_to_import)*100, 2)

####################### Time to plot #######################
library(ggplot2)
library(RColorBrewer)

colfunc  <- colorRampPalette(c("steelblue4", "steelblue1"))
my_color <- colfunc(lines_to_import)

my_barplot <- ggplot(data = fastq_data, aes(x = File_Name, y = percent_of_total)) +
                geom_bar(stat = "identity", fill = my_color) +
                geom_hline(yintercept = perfect_pool, color = "red2") +
                labs(x="", y="Percent of total reads", title = "Library pooling") +
                theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = rel(0.5)), plot.title = element_text(hjust = 0.5))

my_boxplot <- ggplot(data = fastq_data, aes(x = factor(0), y = percent_of_total)) +
                geom_boxplot(fill = "steelblue4", outlier.shape = NA) +
                geom_jitter(width = 0.2, color = "steelblue1") +
                geom_hline(yintercept = perfect_pool, color = "red2") +
                labs(x="Red line = perfect pool", y="Percent of total reads", title = "Library pooling") +
                theme(axis.text.x = element_blank(), axis.ticks.x=element_blank(), plot.title = element_text(hjust = 0.5))


# Save the plots with ggsave
ggsave(filename = "Bar_plot.pdf", plot = my_barplot, device = "pdf", width = 5, height = 3, units = "in")
ggsave(filename = "Box_plot.pdf", plot = my_boxplot, device = "pdf", width = 3, height = 5, units = "in")

# Write table to working directory in case you want to edit the data in R manually
write.table(fastq_data, sep = "\t", "reads_per_fastq_forR.txt", quote = F, row.names = F)

