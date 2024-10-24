#!/usr/bin/env bash
#SBATCH --time=04:00:00  		# Maximum amount of real time for the job to run in HH:MM:SS
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1    # Number of nodes and processors per node requested by job
#SBATCH --mem=8gb           	# Maximum physical memory to use for job
module purge
module load anaconda3 &>/dev/null || source "$(dirname $(which conda))/../etc/profile.d/conda.sh" || (echo 'make sure you have conda installed'; exit 1)
set -eu

# temporary
# conda activate /projects/enviro_lab/decon_compare/benchmark-deconvolute-redo/conda/env-mosdepth
conda activate conda/env-mosdepth

gene_bed=$1
prefix=$2
bam=$3

# if [[ ! -f ${bam}.bai ]]; then
    echo "indexing ${bam}"
    module load samtools
    samtools index ${bam}
# fi

echo "running mosdepth"
echo "CMD: mosdepth --fast-mode --no-per-base --threads 4 --by $gene_bed --thresholds 0,1,10,30,100,500,1000,5000,10000 $prefix ${bam}"
mosdepth --fast-mode --no-per-base --threads 4 --by $gene_bed --thresholds 0,1,10,30,100,500,1000,5000,10000 $prefix ${bam}

echo "done"