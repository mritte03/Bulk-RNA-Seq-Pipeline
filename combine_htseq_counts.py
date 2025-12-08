#!/usr/bin/env python3
# Combines HTSeq count files in the current directory into a single table
# Madison Ritter, 12-8-2025

# USAGE: python combine_htseq_counts.py OUTPUT_PREFIX

import pandas as pd
import glob
import os
import sys

if len(sys.argv) < 2:
    sys.exit("ERROR: You must provide an output prefix.\nUSAGE: python combine_htseq_counts.py OUTPUT_PREFIX")

OUTPUT_PREFIX = sys.argv[1]

files = sorted(glob.glob("*.counts.txt"))
if len(files) == 0:
    print("ERROR: No *.counts.txt files found in current directory.")
    sys.exit("NOTE: Make sure to work from the directory of your count files.")

print(f"Found {len(files)} count files to combine.")
for f in files:
    print("  -", f)

sample_names = [os.path.splitext(f)[0] for f in files]

dfs = []
for file, name in zip(files, sample_names):
    df = pd.read_csv(file, sep="\t", header=None, names=["Gene", name])
    dfs.append(df)

# Merge on "Gene"
merged = dfs[0]
for df in dfs[1:]:
    merged = pd.merge(merged, df, on="Gene", how="outer")

# Sort by Gene name
merged = merged.sort_values("Gene")
merged.to_csv(f"{OUTPUT_PREFIX}.txt", sep="\t", index=False)
print(f"\n Combined counts written to {OUTPUT_PREFIX}.txt")
