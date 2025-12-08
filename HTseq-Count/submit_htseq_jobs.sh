#!/bin/bash
# Submits individual HTSeq count jobs for each sorted SAM file in the current directory
# Madison Ritter, 12-8-2025

# DEPENDENCY: get_htseq_counts_single.sh
# USAGE: bash submit_htseq_jobs.sh get_htseq_counts_single.sh /path/to/annotation.gtf
# NOTE: be sure to update get_htseq_counts_single.sh with appropriate flags before running!!

GET_HTSEQ_COUNTS_SINGLE_FILE=$1
GTF_FILE=$2

### sanity checks ###
shopt -s nullglob
files=(*.sorted.sam)

if [ ${#files[@]} -eq 0 ]; then
    echo "ERROR: No *.sorted.sam files found in current directory."
    echo "NOTE: Make sure to work from the directory of your SAM files."
    exit 1
fi

echo "Found ${#files[@]} sorted SAM files."
for f in "${files[@]}"; do
    echo "  - $f"
done

### submit jobs ###
for samfile in *.sorted.sam
do
    sbatch "$GET_HTSEQ_COUNTS_SINGLE_FILE" "$samfile" "$GTF_FILE"
done
