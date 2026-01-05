#!/usr/bin/env nextflow

process ANNOTATE {
    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir

    input:
    path(filteredbed)
    path(gtf)
    path(genome)

    output:
    path("annotated_peaks.txt")

    script:
    """
    annotatePeaks.pl ${filteredbed} ${genome} -gtf ${gtf}  > annotated_peaks.txt
    """

    stub:
    """
    touch annotated_peaks.txt
    """
}


