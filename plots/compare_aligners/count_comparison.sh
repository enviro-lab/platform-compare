#!/usr/bin/env bash

module load samtools
set -eu
bam_counts=plots/compare_aligners/bam_counts.csv
echo "aligner,background,sample,num_reads" > $bam_counts
for aligner in bwa minimap2; do
    for background in wb nwrb pwrb; do
        for bam in platforms/illumina_${aligner}/${background}/alignments/*.bam; do
            mixture=$(basename $bam .bam)
            echo "${aligner},${background},${mixture},$(samtools view -c $bam)" >> $bam_counts
        done
    done
done