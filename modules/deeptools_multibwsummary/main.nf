#!/usr/bin/env nextflow

process MULTIBWSUMMARY {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir

    input:
    path(bigwig)

    output:
    path("bw_all.npz")

    script:
    """
    multiBigwigSummary bins -b ${bigwig} -o bw_all.npz -p ${task.cpus}
    """

    stub:
    """
    touch bw_all.npz
    """
}