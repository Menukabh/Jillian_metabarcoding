# 16s rRNA analysis of Jillian

## This repo contains code used to perform the metabarcoding analysis of the project
**Whole wheat bread improves postprandial glucose tolerance in adults with prediabetes: a controlled-feeding randomized crossover trial with microbiome-associated variation in response** <https://www.frontiersin.org/journals/nutrition/articles/10.3389/fnut.2026.1907908/full>

## Moved old analysis to single folder old folder
```bash
mkdir old_analysis
mv log_files old_analysis
mv raw_data old_analysis
touch .gitignore
```

## New analysis - with total number of 304 files
```bash
mkdir scripts results
touch scripts/fastqc.sh scripts/mutiqc.sh ## Run fastqc

# Run fastqc
for fastq in raw_data_12_11_2025/*fastq.gz; do
    sbatch scripts/fastqc.sh "$fastq" results/fastqc
done

# Run multiqc
sbatch scripts/mutiqc.sh results/multiqc results/fastqc

# Run Cutadapt
sbatch scripts/cutadapt.sh
```

## They had issues of primers, so check if they are present after trimming primers with cutadapt


