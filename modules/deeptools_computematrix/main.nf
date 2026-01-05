#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_high'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir

    input:
    val(window)
    path(uscs_genes)
    tuple val(sample_id), path(bigwigs)

    output:
    tuple val(sample_id), path("${sample_id}_matrix.gz")

    script:
    """
    computeMatrix scale-regions -S ${bigwigs} -R ${uscs_genes} -b ${window} -a ${window} -o ${sample_id}_matrix.gz
    """

    stub:
    """
    touch ${sample_id}_matrix.gz
    """
}