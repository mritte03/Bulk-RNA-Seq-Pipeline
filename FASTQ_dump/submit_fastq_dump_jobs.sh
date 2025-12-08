#!/bin/bash
# Takes in multiple SRR accession numbers and runs fastq-dump to download the corresponding FASTQ files
# Madison Ritter, 12-8-2025

# DEPENDENCY: single_fastq_dump.sh
# USAGE: sbatch submit_fastq_dump_jobs.sh SINGLE_FASTQ_DUMP_FILE SRR### SRR### ...

# Use $1 if it is a directory; otherwise use current working directory

SINGLE_FASTQ_DUMP_FILE=$1
shift

for SRR in "$@"; do
    sbatch "$SINGLE_FASTQ_DUMP_FILE" "$SRR"
done
