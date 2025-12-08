#!/bin/bash
# Takes a refernece genome index and * PAIRED-END * FASTQ file to perform STAR alignment
# Madison Ritter, 12-8-2025

# DEPENDENCY: run_star_alignment_PAIRED.sh  * or *  run_star_alignment_SINGLE.sh
# USAGE: sbatch submit_star_alignment_jobs.sh JOB_SCRIPT GENOME_INDEX
# NOTE: be sure to work in the directory containing the FASTQ files

RUN_ALIGNMENT_FILE="$1"
GENOME_INDEX="$2"

for FASTQ in *.fastq; do
    echo "Submitting STAR job for: $FASTQ"
    sbatch "$RUN_ALIGNMENT_FILE" "$GENOME_INDEX" "$FASTQ" 
done