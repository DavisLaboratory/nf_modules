process RUN_STAR_ALIGN {
    
    cpus 8
    memory "48.G"
    time "4.h"
    container "quay.io/biocontainers/star:2.7.10b--h9ee0642_0"
    tag "$sample"
    // publishDir "results/${params.project}/aligned"

    input:
    tuple val(sample), path(reads)
    path(index)
    val(read_len)
    path(junctions)

    output:
    tuple val(sample), path(alignment)
    path(splice_junc)
    path(star_log)

    script:
    // println(junctions)

    alignment = "${sample}_Aligned.sortedByCoord.out.bam"
    splice_junc = "${sample}_SJ.out.tab"
    star_log = "${sample}_Log.final.out"
    overhang = read_len - 1
    pass2 = junctions.name != "NO_FILE" ? "--sjdbFileChrStartEnd ${junctions}" : ""
    // above, if the junctions input is default: make empty, otherwise add the junctions for 
    // second pass mapping 
    """
    STAR --genomeDir $index \
         --runThreadN $task.cpus \
         --readFilesIn ${reads[0]} ${reads[1]} \
         --outSAMtype BAM SortedByCoordinate \
         --readFilesCommand zcat \
         --outFileNamePrefix ${sample}_ \
         --sjdbOverhang $overhang \
         --alignSJDBoverhangMin 1 \
         --alignSJoverhangMin 8 \
         --alignIntronMin 20 \
         --alignIntronMax 500000 \
         --alignMatesGapMax 1000000 \
         --chimJunctionOverhangMin 15 \
         --chimMainSegmentMultNmax 1 \
         --chimOutType Junctions SoftClip \
         --chimSegmentMin 15 \
         --outFilterType BySJout \
         --outFilterMultimapNmax 20 \
         --outFilterMismatchNmax 999 \
         --outFilterMismatchNoverLmax 0.04 \
         --outFilterMatchNminOverLread 0.33 \
         --outFilterScoreMinOverLread 0.33 \
         --outMultimapperOrder Random ${pass2}
        
    """

}



