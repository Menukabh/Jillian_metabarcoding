#!/bin/bash
#SBATCH --account=PAS0471
#SBATCH --output=slurm-cutadapt.out
#SBATCH --cpus-per-task=8

# Strict bash settings
set -euo pipefail

# Load the software
module load miniconda3/24.1.2-py310
source activate /fs/ess/PAS0471/conda/cutadapt_v5.1

# Primer sequences
primer_f=CCTACGGGNGGCWGCAG
primer_r=GACTACHVGGGTATC

# Get the reverse-complements of the primers
primer_f_rc=$(echo "$primer_f" | tr ATCGYRKMBDHV TAGCRYMKVHDB | rev)
primer_r_rc=$(echo "$primer_r" | tr ATCGYRKMBDHV TAGCRYMKVHDB | rev)

# Create the output dir
outdir=results/cutadapt
mkdir -p "$outdir"

# Loop over the R1 files
for R1_in in raw_data_12_11_2025/*R1_001.fastq.gz; do
    # Get the R2 file name
    R2_in=${R1_in/_R1/_R2}
    
    # Report
    echo "Input files: $R1_in $R2_in"
    
    # Define the output files
    R1_out="$outdir"/$(basename "$R1_in")
    R2_out="$outdir"/$(basename "$R2_in")
    
    # Run Cutadapt
    cutadapt \
            -a "$primer_f"..."$primer_r_rc" \
            -A "$primer_r"..."$primer_f_rc" \
            --trimmed-only \
            --cores 8 \
            --output "$R1_out" \
            --paired-output "$R2_out" \
            "$R1_in" "$R2_in"
done

# Report
echo "Done with script cutadapt.sh"
date