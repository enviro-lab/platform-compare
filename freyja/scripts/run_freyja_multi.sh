#!/usr/bin/env bash
#SBATCH --time=04:00:00  		# Maximum amount of real time for the job to run in HH:MM:SS
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6    # Number of nodes and processors per node requested by job
#SBATCH --mem=2gb           	# Maximum physical memory to use for job
#SBATCH --job-name=freyja_runs
#SBATCH --output=freyja/slurm/main-run-%j.out
date
module purge &>/dev/null
module load anaconda3 &>/dev/null || source "$(dirname $(which conda))/../etc/profile.d/conda.sh" || (echo 'make sure you have conda installed'; exit 1)
set -eu

ref=software/sars-cov-2-reference.fasta
agg_dir="freyja/agg"
mkdir -p ${agg_dir}

backgrounds="wb nwrb pwrb"
platforms="cg ont illumina_ss"
platforms="cg illumina_ss"
platforms="illumina_bwa illumina_minimap2"

for platform in $platforms; do

    for background in $backgrounds; do

        (
        bam_dir=platforms/${platform}/${background}/alignments
        outdir=platforms/${platform}/${background}/freyja
        demixed=${outdir}/demixed
        mkdir -p ${demixed}

        # # (FIRST RUN) run freyja for each plate
        # for bam in ${bam_dir}/*.bam; do
        #     sample=$(basename ${bam} .bam | cut -d'_' -f1)

        #     echo "running freyja for ${sample} ${platform} ${background}..."

        #     ## only use one of the below options:

        #     # # a) for one-at-a-time
        #     # bash freyja/scripts/run_freyja.sh $ref $bam $outdir $sample

        #     # b) for batch submission
        #     job_name=freyja_${platform}_${background}_${sample}
        #     mkdir -p freyja/slurm
        #     sbatch --output=freyja/slurm/freyja_${platform}_${background}_${sample}-%j.out --job-name=$job_name freyja/scripts/run_freyja.sh $ref $bam $outdir $sample
        # done

        # # wait for all freyja jobs to finish (in case of batch submission)
        # # note, this could wait forever if freyja jobs fail to produce demix output
        # while true; do
        #     if [[ $(ls $bam_dir/*.bam | wc -l) -eq $(ls $demixed | wc -l) ]]; then break; else sleep 5; fi
        # done
        # sleep 5

        # # this env should have freyja and freyja-plot installed
        # # temporary
        # conda activate /projects/enviro_lab/decon_compare/benchmark-deconvolute-redo/conda/env-plot
        conda activate conda/env-plot

        # aggregate demix files...
        agg_file="${agg_dir}/${platform}-${background}.tsv"
        echo "${platform} ${background}: aggregating files from $demixed to $agg_file..."
        freyja aggregate $demixed/ --output ${agg_file}
        ) &

    done
done

wait
printf "Freyja runs complete -"
date