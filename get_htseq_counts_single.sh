#!/bin/bash
# Takes sorted SAM file and GTF annotation file and runs HTseq-count to generate gene counts
# Madison Ritter, 12-8-2025

# USAGE: sbatch get_htseq_counts_single.sh sample.sorted.sam /path/to/annotation.gtf
# NOTE: can be used with submit_htseq_jobs.sh to run EACH sorted same file as a separate slurm job
# NOTE: be sure to update the flags before running ie. strandedness (-s) and gene_id/name (-i)!!

#SBATCH -c 4
#SBATCH --mem=16G
#SBATCH --job-name=htseq_counts
#SBATCH -o Logs/htseq_%j.out
#SBATCH -e Logs/htseq_%j.err
#SBATCH -t 1-00:00:00

source ~/miniconda3/etc/profile.d/conda.sh
conda activate htseq_env

SAMFILE="$1"
GTF_FILE="$2"

mkdir -p "Counts"

sample=$(basename "$SAMFILE" .sorted.sam)
echo "Running HTSeq for $sample..."

# -s can be yes, no, or reverse depending on strandedness
# -i may need to be gene_name or gene_id depending on GTF

python -m HTSeq.scripts.count \
    -f sam \
    -r pos \
    -s reverse \
    -t exon \
    -i gene_name \
    "$SAMFILE" \
    "$GTF_FILE" \
    > "Counts/${sample}.counts.txt"

echo "HTSeq-count finished for $sample."
