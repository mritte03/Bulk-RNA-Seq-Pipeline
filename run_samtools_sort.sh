#!/bin/bash
# Takes SAM files with Aligned.out.sam suffix and sorts them using samtools
# Madison Ritter, 12-8-2025

# USAGE: sbatch -c 16 --mem=20G -t 1:00:00 run_samtools_sort.sh
# NOTE: be sure to work in the directory containing the .Aligned.out.sam files

#SBATCH -c 16
#SBATCH --mem=64G
#SBATCH --job-name=samtools_sort
#SBATCH -o Logs_sorted/samtools_sort_%j.out
#SBATCH -e Logs_sorted/samtools_sort_%j.err
#SBATCH -t 1:00:00   # adjust time as needed

module load samtools/1.21 || { echo "ERROR: samtools failed to load" >&2; exit 1; }

shopt -s nullglob
files=(*.Aligned.out.sam)

if [ ${#files[@]} -eq 0 ]; then
    echo "ERROR: No *.Aligned.out.sam files found in current directory."
    echo "NOTE: Make sure to work from the directory of your SAM files."
    exit 1
fi

echo "Found ${#files[@]} aligned SAM files."
for f in "${files[@]}"; do
    echo "  - $f"
done

mkdir -p "SAMs_sorted" "Logs_sorted"

for file in *.Aligned.out.sam
do
    filename=$(basename "$file" .Aligned.out.sam)

    echo "Sorting $filename..."

    samtools sort \
        -m 1G \
        -@ 16 \
        -o "SAMs_sorted/${filename}.sorted.sam" \
        -O sam \
        -T "SAMs_sorted/${filename}_tmp" \
        "$file"
done

echo "All SAM files have been sorted."
