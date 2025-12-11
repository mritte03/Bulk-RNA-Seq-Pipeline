#!/bin/bash
# Runs STAR alignment for all * PAIRED-END * FASTQ files in the current directory
# Madison Ritter, 12-11-2025

# DEPENDENCY: run_star_alignment_PAIRED.sh
# USAGE: sbatch submit_star_alignment_jobs_PAIRED.sh run_star_alignment_PAIRED.sh GENOME_INDEX
# NOTE: be sure to work in the directory containing the FASTQ files

RUN_ALIGNMENT_FILE="$1"   # path to run_alignment.sh
GENOME_INDEX="$2"         # path to STAR genome index

for r1 in *_R1_001.fastq.gz; do
    r2="${r1/_R1_/_R2_}"

    if [[ ! -f "$r2" ]]; then
        echo "WARNING: Paired file not found for $r1, skipping..."
        continue
    fi

    echo "Submitting STAR job for: $r1 and $r2"
    sbatch "$RUN_ALIGNMENT_FILE" "$GENOME_INDEX" "$r1" "$r2"
done
