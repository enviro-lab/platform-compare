#!/usr/bin/env bash
set -eu
## This scripts is for linking local files and won't work outside of our cluster

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# link to illumina and cg files
declare -A renames
renames["WB"]="wb"
renames["NW"]="nwrb"
renames["PW"]="pwrb"

declare -A directories
directories["cg"]="/projects/enviro_lab/WW-UNCC/MixedControl-completeGenomics-fastqs/output/alignments"
directories["illumina_ss"]="/projects/enviro_lab/WW-UNCC/Control_Mixture_Illumina/output/alignments"
directories["illumina_minimap2"]="/projects/enviro_lab/WW-UNCC/Control_Mixture_Illumina_Run2/output_minimap2/alignments"
directories["illumina_bwa"]="/projects/enviro_lab/WW-UNCC/Control_Mixture_Illumina_Run2/output_bwa/alignments"

# for platform in cg illumina_old; do
# for platform in illumina_minimap2; do
for platform in illumina_bwa; do
    alignment_dir=${directories[$platform]}

    for background in WB NW PW; do
        bg_rename=${renames[$background]}
        mkdir -p ${this_dir}/$platform/${bg_rename}/alignments

        for file in $alignment_dir/${background}*.resorted.bam; do
            sample=$(basename $file .resorted.bam)
            mixture=${sample#*-M}
            if [[ ${#mixture} -eq 1 ]]; then mixture="0${mixture}"; fi
            mixture="Mixture${mixture}"
            echo ln -s $file ${this_dir}/${platform}/${bg_rename}/alignments/${mixture}.bam
            ln -s $file ${this_dir}/${platform}/${bg_rename}/alignments/${mixture}.bam
            echo ln -s $file.bai ${this_dir}/${platform}/${bg_rename}/alignments/${mixture}.bam.bai
            ln -s $file.bai ${this_dir}/${platform}/${bg_rename}/alignments/${mixture}.bam.bai
        done
    done
done


# # link to ont files
# platform=ont

# declare -A ont_renames
# ont_renames["05-05-23-A41"]="wb"
# ont_renames["05-16-23-A41"]="nwrb"
# ont_renames["06-26-23-A41"]="pwrb"

# for plate in 05-05-23-A41 05-16-23-A41 06-26-23-A41; do
#     alignment_dir=/projects/enviro_lab/decon_compare/benchmark-deconvolute-redo/ont/MixedControl-${plate}-fastqs/output/alignments
#     bg_rename=${ont_renames[$plate]}
#     mkdir -p ${this_dir}/$platform/${bg_rename}/alignments

#     for file in $alignment_dir/*.bam; do
#         sample=$(basename $file .bam)
#         mixture=${sample%_barcode*}
#         ln -s $file ${this_dir}/${platform}/${bg_rename}/alignments/${mixture}.bam
#         ln -s $file.bai ${this_dir}/${platform}/${bg_rename}/alignments/${mixture}.bam.bai
#     done
# done