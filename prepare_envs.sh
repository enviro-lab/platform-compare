#!/usr/bin/env bash
module purge
module load anaconda3 &>/dev/null || source "$(dirname $(which conda))/../etc/profile.d/conda.sh" || (echo 'make sure you have conda installed'; exit 1)
set -eu

### This creates the conda envs for running these analyses

this_dir="$( realpath "$( dirname "${BASH_SOURCE[0]}" )" )"
cd ${this_dir}


## for plotting/analysis
# mamba create -y -p conda/env-plot -c conda-forge -c bioconda python=3.10 freyja
conda activate conda/env-plot
pip install freyja-plot
# # if running jupyter notebooks, install ipykernal. Neither of one of these worked for me but installing it directly from within visual studio code did.
# pip install ipykernal
# mamba install ipykernel
mamba install -y 'nbformat>=4.2.0'
# for stats:
mamba install -y -c researchpy researchpy
conda deactivate


## for mosdepth
mamba create -y -p conda/env-mosdepth -c bioconda mosdepth
