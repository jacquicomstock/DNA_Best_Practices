# All the below commands were typed manually into the command line and not run as a script
# These are the commands I used to upload, move & unzip files, & run the other attached scripts as batch jobs in the cluster

#in local terminal
scp -r M17.zip jcomstock@pod.cnsi.ucsb.edu:/home/jcomstock/M17/
scp -r silva_nr99_v138.1_wSpecies_train_set.fa.gz jcomstock@pod.cnsi.ucsb.edu:/home/jcomstock/M17/

#switch to cluster terminal window
#change to appropriate directory
cd M17

#to unzip all .zip files
unzip '*.zip'

#move zipped files to a new folder to keep things organized
mkdir zipped_fastqs
mv *.zip zipped_fastqs/

#make directory for fastqs and move them there
mkdir fastqs
mv *.fastq.gz fastqs/

#move SILVA database to the same directory as the unzipped fastqs & move into that directory
mv *.fa.gz fastqs/
cd fastqs

#make filtered directory for DADA2
mkdir filtered

#activate conda environment with R
conda activate R4.2.0

#make dada2 R script
vi M17_dada2.R
#paste the dada2 R script into this new file and press esc
:w
:q

#submit batch job to slurm to run dada2 pipeline
sbatch \
	--job-name=M17_dada2 \
	--nodes=1 \
	--tasks-per-node=32 \
	--cpus-per-task=1 \
	--mem=80G \
	--time=4:00:00 \
	--output=dada2_out \
	--error=dada2_err \
	--wrap="Rscript M17_dada2.R"
