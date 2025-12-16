#!/bin/bash
# Takes a reference genome index and * PAIRED-END * FASTQ file to perform STAR alignment
# Madison Ritter, 12-16-2025

# USAGE: sbatch run_star_alignment_PAIRED.sh GENOME_INDEX READ_1.fqz READ_2.fq.gz
# NOTE: use submit_star_alignment_jobs_PAIRED.sh to run EACH FASTQ read pair as a separate slurm job
# NOTE: be sure to work in the directory containing the FASTQ files

# NOTE: you may need to modify the filename patterns below based on how your FASTQ files are named

#SBATCH -c 16
#SBATCH --mem=64G
#SBATCH -t 4:00:00
#SBATCH --job-name=star_paired_end
#SBATCH -o Logs/%x_%A.out
#SBATCH -e Logs/%x_%A.err

GENOME_INDEX="$1"
R1="$2"
R2="$3"

module load star/2.7.11b || { echo "ERROR: STAR failed to load" >&2; exit 1; }
echo "star/2.7.11b loaded successfully."

mkdir -p SAMs

### NOTE: CHANGE THE FOLLOWING LINE TO REFLECT YOUR FILE FORMAT
filename="${R1%.R1.fq}" # in the last argument, include the non-essential filename ending

echo "Aligning $filename (paired-end)..."

STAR \
    --genomeDir "$GENOME_INDEX" \
    --runThreadN 16 \
    --readFilesIn "$R1" "$R2" \
    --readFilesCommand zcat \
    --outFileNamePrefix "SAMs/${filename}." \
    --outSAMtype SAM \
    --outFilterType BySJout \
    --outFilterMultimapNmax 20 \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1 \
    --outFilterMismatchNmax 999 \
    --outFilterMismatchNoverReadLmax 0.04 \
    --alignIntronMin 20 \
    --alignIntronMax 1000000
