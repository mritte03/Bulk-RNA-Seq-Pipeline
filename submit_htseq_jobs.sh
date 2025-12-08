#!/bin/bash
# Submits individual HTSeq count jobs for each sorted SAM file in the current directory
# Madison Ritter, 12-8-2025

# DEPENDENCY: get_htseq_counts_single.sh
# USAGE: bash submit_htseq_jobs.sh get_htseq_counts_single.sh /path/to/annotation.gtf
# NOTE: be sure to update get_htseq_counts_single.sh with appropriate flags before running!!

BASE_DIR="$(pwd)"
GET_HTSEQ_COUNTS_SINGLE_FILE=$1
GTF_FILE=$2

for samfile in "$BASE_DIR"/*.sorted.sam
do
    sbatch "$GET_HTSEQ_COUNTS_SINGLE_FILE" "$samfile" "$GTF_FILE"
done