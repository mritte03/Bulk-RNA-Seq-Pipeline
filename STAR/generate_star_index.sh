#!/bin/bash
# Takes reference FASTA and GTF files to generate STAR genome index
# Madison Ritter, 12-8-2025

# USAGE: sbatch generate_star_index.sh reference.fa annotation.gtf INDEX_PREFIX
# NOTE: be sure to work in the directory containing the reference.fa and annotation.gtf files

#SBATCH -c 16
#SBATCH -t 4:00:00   # 4 hours
#SBATCH --mem=64G
#SBATCH --job-name=generate_star_index
#SBATCH -o Logs/index_%j.out
#SBATCH -e Logs/index_%j.err

module load star/2.7.11b || { echo "ERROR: STAR failed to load" >&2; exit 1; }
echo "star/2.7.11b loaded successfully."

FASTA=$1
GTF=$2
INDEX_PREFIX=$3 # Prefix for the STAR genome index directory (e.g. hg38_index, mm39_index)

INDEX_OUT_DIR="${INDEX_PREFIX}_STAR_index"

mkdir -p "$INDEX_OUT_DIR"

STAR --runMode genomeGenerate \
     --runThreadN 16 \
     --genomeDir "$INDEX_OUT_DIR" \
     --genomeFastaFiles "$FASTA" \
     --sjdbGTFfile "$GTF" \
     --sjdbOverhang 99 \

echo "STAR genome index generated in $INDEX_OUT_DIR"
