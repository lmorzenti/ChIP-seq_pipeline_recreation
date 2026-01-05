#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir

    input:
    path(bedfile)
    path(blacklist)

    output:
    path("repr_peaks_filtered.bed")

    script:
    """
    bedtools subtract -a ${bedfile} -b ${blacklist} > repr_peaks_filtered.bed
    """

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}