## Check the presence of primers
## reads would have spacers, primers, amplicon
## Cutadapt find everything before the primer or sequence provided.
## Forward primers- CCTACGGGNGGCWGCAG, where N means either ATGC and W means A or T
zgrep -c "CCTACGGG[ATGC]GGC[AT]GCAG" raw_data/504A0_S1_L001_R1_001.fastq.gz

## Include the spacers- TCGATCG and ATCTGTCATG
zgrep -c "TCGATCGCCTACGGG[ATGC]GGC[AT]GCAG" raw_data/504A0_S1_L001_R1_001.fastq.gz
zgrep -c "ATCTGTCATGCCTACGGG[ATGC]GGC[AT]GCAG" raw_data/504A0_S1_L001_R1_001.fastq.gz

## Reverse primers- GACTACHVGGGTATC, where H means ACT and V means ACG and GACTACHVGGGT
zgrep -c "GACTAC[ACT][ACG]GGGT" raw_data/504A0_S1_L001_R2_001.fastq.gz
zgrep -c "GACTAC[ACT][ACG]GGGTATC" raw_data/504A0_S1_L001_R2_001.fastq.gz

## Run fastqc
for fastq in raw_data/*fastq.gz; do
    sbatch scripts/fastqc.sh "$fastq" results/fastqc
done

# Run multiqc
sbatch scripts/multiqc.sh results/fastqc results/multiqc

## Run cutadapt
sbatch scripts/cutadapt.sh
## The primer percentage in the reads should be greater than 90%
grep "with adapter:" slurm-cutadapt.out > cutadapat_output_average


## Run fastqc in the cutadapt output
for fastq in results/cutadapt/*fastq.gz; do
    sbatch scripts/fastqc.sh "$fastq" results/fastqc_cutadapt
done

## Run multiqc after cutadapat
sbatch scripts/multiqc.sh results/fastqc_cutadapt results/multiqc_cutadapt

## Look for the primer seqeunce after running cutadapt to see if it has been removed
zgrep -c "TCGATCGCCTACGGG[ATGC]GGC[AT]GCAG" results/cutadapt/504A0_S1_L001_R1_001.fastq.gz
zgrep -c "ATCTGTCATGCCTACGGG[ATGC]GGC[AT]GCAG" results/cutadapt/504A0_S1_L001_R1_001.fastq.gz

## Other steps
1. Fastqc & Multiqc
2. Cutadapat to remove primers and adapter
3. quality filtering (removing poor-quality reads) and trimming (both removes poor-quality bases)-DADA2
4. Dereplication-condense reads that encodes same sequences
5. ASV - DADA2
6. Merge forward and reverse reads
7. Construct seqeunce table
8. remove chimera
9. Generate summary table
10. Assign taxonomy to ASVs
11. Generate output files: metadata, taxa, ASV
12. Identify and remove contaminants
13. Remove non bacterial or non-archeal ASV
14. Filter samples with low taxonomic counts
15. Normalization: of read deapth, rarefaction curve
16. Plot abundance
17. Alpha diversity= Taxonomic richness, frequency counts, diversity indices
18. beta diversity= ordination plot(PCOA), PERMANOVA























