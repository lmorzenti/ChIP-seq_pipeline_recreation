//modules are here:
include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {MULTIQC} from './modules/multiqc'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {MULTIBWSUMMARY} from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {PLOTPROFILE} from './modules/deeptools_plotprofile'
include {TAGDIR} from './modules/homer_maketagdir'
include {FINDPEAKS} from './modules/homer_findpeaks'
include {POS2BED} from './modules/homer_pos2bed'
include {BEDTOOLS_INTERSECT} from './modules/bedtools_intersect'
include {BEDTOOLS_REMOVE} from './modules/bedtools_remove'
include {ANNOTATE} from './modules/homer_annotatepeaks'
include {FIND_MOTIFS_GENOME} from './modules/homer_findmotifsgenome'

workflow {
    //These samples are single end
    //After peak calling input & ip calling don't mean anything anymore 
    
    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch }

    FASTQC( read_ch ) 

    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch2 }

    TRIM(params.adapter_fa, read_ch2)

    BOWTIE2_BUILD(params.genome)
    BOWTIE2_ALIGN(FASTQC.out.reads, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.index_name)

    SAMTOOLS_SORT(BOWTIE2_ALIGN.out)
    SAMTOOLS_IDX(SAMTOOLS_SORT.out)

    BAMCOVERAGE(SAMTOOLS_IDX.out)

    BAMCOVERAGE.out
      .map {sample_id, bw -> bw}
      .collect()
      .set {bigwigs_grouped}

    MULTIBWSUMMARY(bigwigs_grouped)
    PLOTCORRELATION(MULTIBWSUMMARY.out)

    COMPUTEMATRIX(params.window, params.ucsc_genes, BAMCOVERAGE.out)
    PLOTPROFILE(COMPUTEMATRIX.out)

    SAMTOOLS_FLAGSTAT(BOWTIE2_ALIGN.out)

    multiqc_channel = FASTQC.out.zip
       .map { it[1] }
       .mix(TRIM.out.log)
       .mix(SAMTOOLS_FLAGSTAT.out.map { it[1] })
       .collect()
    //

    //multiqc_channel.view()

    MULTIQC(multiqc_channel)

    TAGDIR(BOWTIE2_ALIGN.out.bam)

    //Making channels that organize the bam files for use in find peaks 
    TAGDIR.out.branch { it ->
    rep1: it[0].contains("_rep1")
    rep2: it[0].contains("_rep2")
    }
    .set{tagdir_ch}

    tagdir_ch.rep1
       .map { sample_id, tagdir -> tuple("rep1", sample_id.startsWith("IP_") ? "ip" : "input", tagdir) }
       .groupTuple(by: 0)
       .map { rep_id, types, tagdir -> 
         def ip_dir = tagdir[types.indexOf("ip")]
         def input_dir = tagdir[types.indexOf("input")]
         tuple(rep_id, ip_dir, input_dir)
    }
    .set { rep1_paired }


   tagdir_ch.rep2
       .map { sample_id, tagdir -> tuple("rep2", sample_id.startsWith("IP_") ? "ip" : "input", tagdir) }
       .groupTuple(by: 0)
       .map { rep_id, types, tagdir -> 
         def ip_dir = tagdir[types.indexOf("ip")]
         def input_dir = tagdir[types.indexOf("input")]
         tuple(rep_id, ip_dir, input_dir)
    }
    .set { rep2_paired }
   
    rep2_paired.mix(rep1_paired).set { directories }

    directories.view()

    FINDPEAKS(directories)
    POS2BED(FINDPEAKS.out)
    
    //Make a tuple for bedtools intersect
    POS2BED.out
      .map { sample_id, bed_file -> bed_file }
      .collect()
      .set { peak_files }

    BEDTOOLS_INTERSECT(peak_files)
    //please provide a quick statement on how you chose to come up with a consensus set of peaks

    BEDTOOLS_REMOVE(BEDTOOLS_INTERSECT.out, params.blacklist)
    // going with the default as the website says default is 1bp overlap which is fine for this project

    ANNOTATE(BEDTOOLS_REMOVE.out, params.gtf, params.genome)

    FIND_MOTIFS_GENOME(BEDTOOLS_REMOVE.out, params.genome)


}
