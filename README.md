# Recreation of ChIP-seq Analysis from "RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells", Barutcu et al., 2016.

## Background
The RUNX1 transcription factor is a part of a family of proteins that are known for being master regulators. Their well defined behavior has inherently tied them into playing important roles in cancer development. RUNX1 specifically has been strongly associated with breast cancer, where it can act as both a tumor suppressor and an oncogene. RUNX1 acts through the alteration of chromatin structure alongside other chromatin modifiers and remodeling enzymes. The study in question specifically aimed to investigate the relationship between RUNX1 mediated transcription and the resulting genome organization. As changes in nuclear architecture are often observed in cases of breast cancer alongside the overexpression of RUNX1, investigating this relationship will help make a more complete picture into breast cancer development. To approach this problem, the authors used a variety of different methods with two conditions, cells with a suppression RUNX1 and cells with no suppression of RUNX1. First, the authors employed a Hi-C approach in order to examine both inter- and intra-chromosomal interactions between both conditions. Next, they utilized RNA-seq analysis in order to compare the gene expression profile of these two conditions. In addition to this, the authors performed a ChIP-seq analysis in order to investigate RUNX1-mediated regulation of chromatin organization through its binding patterns on the chromatin.

## Data Source
This project uses single end Chip-seq reads that were generated from Barutcu et al. (2016), which investigates if RUNX1-dependent differences in gene expression that the authors previously determined were related to RUNX1 binding.  

**Data**: ChIP-seq data from NCBI GEO, accession code: GSE75070.

## Running the Pipeline
Prerequisites: Ensure that you have nextflow installed and ready to use on your system.

Clone this repository 
``` bash 
git clone <ssh>
cd <this-project-directory>
``` 

Running this pipeline
``` bash
nextflow run main.nf -profile singularity,cluster
```

This pipeline assumes that it will receive the data in a csv file formatted as ‘name,path-to-file’ with the data stored in fastq.gz files. The names of the files are expected to resemble ‘<IP or Control>_rep<1 or 2>.fastq.gz’. The pipeline will take this csv file to pass the data through preprocessing, quality control, peak calling, peak annotation, and motif finding. The analysis of the data consists of the replication of 3 key figures from Barutcu et al. (2016) that is done in a Jupyter Notebook labeled as ‘figure_creation_workbook.ipynb’. An example discussion of the recreation can be found in a Jupyter Notebook labeled as ‘discussion_notebook.ipynb’.

## Citation
1. Barutcu AR, Hong D, Lajoie BR, McCord RP, van Wijnen AJ, Lian JB, Stein JL, Dekker J, Imbalzano AN, Stein GS. RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells. Biochim Biophys Acta. 2016 Nov;1859(11):1389-1397. doi: 10.1016/j.bbagrm.2016.08.003. Epub 2016 Aug 9. PMID: 27514584; PMCID: PMC5071180.
