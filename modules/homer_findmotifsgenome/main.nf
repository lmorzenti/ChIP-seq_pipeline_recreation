#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir

    input:
    path(filteredbed)
    path(genome)

    output:
    path("homerResults.html")

    script:
    """
    mkdir motifs
    findMotifsGenome.pl ${filteredbed} ${genome} motifs/ -size given -p ${task.cpus}
    """

    stub:
    """
    mkdir motifs
    touch "homerResults.html"
    """
}


