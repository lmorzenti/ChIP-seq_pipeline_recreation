#!/usr/bin/env nextflow

process PLOTCORRELATION {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir

    input:
    path(bigwig)

    output:
    path("correlation_plot.png")

    script:
    """
    plotCorrelation -in ${bigwig} -c spearman -p heatmap -o correlation_plot.png
    """
    //I chose Spearman because: I don't know how well this data follows a normal distribution 
    stub:
    """
    touch correlation_plot.png
    """
}






