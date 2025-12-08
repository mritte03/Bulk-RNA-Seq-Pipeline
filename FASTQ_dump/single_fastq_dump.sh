#!/bin/bash
# Takes in an SRR accession number and runs fastq-dump to download the corresponding FASTQ file
# Madison Ritter, 12-8-2025

# NOTE: should be run with submit_fastq_dump_jobs.sh to run each SRR as a separate job

#SBATCH --job-name=fastq_dump_single
#SBATCH --time=1-4:00:00
#SBATCH --mem=10G
#SBATCH -o Logs/fastq_dump_%j.out
#SBATCH -e Logs/fastq_dump_%j.err

SRR=$1

echo "Running fastq-dump for: $SRR"
fastq-dump --split-3 "$SRR"
echo "Done Downloading: $SRR"
