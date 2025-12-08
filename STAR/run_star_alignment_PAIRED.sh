#!/bin/bash
# Takes a refernece genome index and * PAIRED-END * FASTQ file to perform STAR alignment
# Madison Ritter, 12-8-2025

# USAGE: sbatch run_star_alignment_PAIRED.sh GENOME_INDEX FILE.fastq
# NOTE: can be used with submit_star_alignment_jobs.sh to run EACH FASTQ as a separate slurm job
# NOTE: be sure to work in the directory containing the FASTQ files

# NOTE: you may need to modify the filename patterns below based on how your FASTQ files are named

#SBATCH -c 16
#SBATCH --mem=64G
#SBATCH -t 4:00:00
#SBATCH --job-name=star_paired_end
#SBATCH -o Logs/star_%x_%A.out
#SBATCH -e Logs/star_%x_%A.err

GENOME_INDEX="$1"   # path to STAR genome index

module load star/2.7.11b || { echo "ERROR: STAR failed to load" >&2; exit 1; }
echo "star/2.7.11b loaded successfully."

mkdir -p SAMs

for r1 in *_R1_001.fastq.gz
do
    r2="${r1/_R1_/_R2_}"

    filename=$(basename "$r1" _R1_001.fastq.gz)

    echo "Aligning $filename (paired-end)..."

    STAR \
        --genomeDir "$GENOME_INDEX" \
        --runThreadN 16 \
        --readFilesIn "$r1" "$r2" \
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
done
