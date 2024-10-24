# platform-compare
Comparison of sequencing platforms with a control dataset.

## Sequencing platforms
This repository contains scripts to compare different sequencing platforms using a dataset that contains known compositions of synthetic SARS-CoV-2 viral control mixtures. The dataset is described more fully in our paper [A Gold Standard Dataset and Evaluation of Methods for Lineage Abundance
Estimation from Wastewater](https://www.medrxiv.org/content/10.1101/2024.02.15.24302811). 

Brand | Platform | Primer scheme
:--- | :--- | :---
ONT | PromethION | ARTIC V4.1
Illumina | NextSeq 2000 | ARTIC V3
Complete Genomics | G99 | ARTIC V3

## About this repository
In the [platforms/](./platforms/) directory, you will find subdirectories for each platform, each containing (locally) the BAMs generated for each dataset along with the scripts used to organize them in preparation for downstream analysis. These are in directories like `platforms/<platform>/<background>/alignments` The actual alignment files are too large to share here but instructions for how to download them can be found in the README.md files for each platform. 

The [plots/](./plots/) directory contains any scripts (mostly jupyter notebooks) used to generate the plots used in understanding the similarities and differences between platforms.

All scripts (and relative paths) used here are expected to be run directly from within the root of this repository. Any jupyter notebook is run from the directory where it is stored.

## Gathering data

## Linking to BAMs
Filtered alignments were . These files were originally produced using variations of our [covid-analysis](https://github.com/enviro-lab/covid-analysis) pipeline currently found on our cluster at `/projects/enviro_lab/scripts/covid-analysis`. The exact nextflow workflow script within that directory can be determined by the table below:

analysis name | platform | paired? | aligner | script
-- | -- | -- | -- | --
ont | PromethION | No | minimap2 | analyzeReads.nf
cg | G99 | No | minimap2 | analyzeReads_cg.nf
illumina_ss | MiSeq2000 | No | minimap2 | analyzeReads_illumina.nf
illumina_minimap2 | MiSeq2000 | Yes | minimap2 | analyzeReads_illumina_ds.nf
illumina_bwa | MiSeq2000 | Yes | bwa | analyzeReads_illumina_ds.nf

Those BAMs were then linked in thier appropriate locations by running [arrange_files.sh](platforms/arrange_files.sh). Note that this script uses absolute paths specific to our directory structure and may only act as a guide.

## Running Freyja (necessary for plots produced in [plots/abundance_analysis](plots/abundance_analysis))
We're comparing all the results using freyja's aggregated output. This can be created by running [run_freyja_multi.sh](freyja/scripts/run_freyja_multi.sh). This works best by running it in two steps:
1. Uncomment the code block marked `(FIRST RUN)` within [run_freyja_multi.sh](freyja/scripts/run_freyja_multi.sh).
2. Comment out the section used before and uncomment the code block marked `(SECOND RUN)`.

## Running mosdepth (necessary for plots produced in [plots/coverage_analysis](plots/coverage_analysis))
To get coverage details for each sample, run [get_coverage_multi.sh](plots/coverage_analysis/scripts/get_coverage_multi.sh). This requires the conda env [conda/env-mosdepth](conda/env-mosdepth) or the mosdepth executable to be in your path.

## Citation
We don't yet have a citation for this repository, but that will be forthcoming. In the meantime, check out our [deconvolution paper](https://www.medrxiv.org/content/10.1101/2024.02.15.24302811) to learn more about our general process. What we did there just on ONT has been expanded here to the other sequencing platforms.