#!/usr/bin/env nextflow

process FINDPEAKS {
    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir

    input:
    tuple val(sample_id), path(ip_dir), path(input_dir)

    output:
    tuple val(sample_id), path("${sample_id}_peaks.txt")

    script:
    """
    findPeaks ${ip_dir} -style factor -o ${sample_id}_peaks.txt -i ${input_dir}
    """

    stub:
    """
    touch ${sample_id}_peaks.txt
    """
}


