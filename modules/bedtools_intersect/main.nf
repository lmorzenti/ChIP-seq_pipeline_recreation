#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir
    
    input:
    tuple path(rep2bed), path(rep1bed)

    output:
    path("repr_peaks.bed")

    script:
    """
    bedtools intersect -a ${rep1bed} -b ${rep2bed} > repr_peaks.bed
    """

    stub:
    """
    touch repr_peaks.bed
    """
}