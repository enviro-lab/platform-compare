#!/usr/bin/env bash


gene_bed=software/gene_locations.bed
backgrounds="wb nwrb pwrb"
platforms="cg ont illumina_ss"
platforms="illumina_minimap2 illumina_bwa"

for platform in $platforms; do

    for background in $backgrounds; do

        bam_dir=platforms/${platform}/${background}/alignments
        outdir=platforms/${platform}/${background}/mosdepth
        mkdir -p ${outdir}

        # run mosdepth for each plate
        for bam in ${bam_dir}/*.bam; do
            sample=$(basename ${bam} .bam | cut -d'_' -f1)

            echo "running mosdepth for ${sample} ${platform} ${background}..."
            prefix=${outdir}/${sample}

            job_name=md_${platform}_${background}_${sample}
            slurm_out=plots/coverage_analysis/slurm
            mkdir -p plots/coverage_analysis/slurm
            sbatch --output=${slurm_out}/mosdepth-%j.out --job-name=${job_name} \
                plots/coverage_analysis/scripts/get_coverage.sh $gene_bed $prefix $bam

        done
    done
done
