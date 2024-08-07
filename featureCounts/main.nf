process RUN_FEATURECOUNTS {
    
    cpus {4 * task.attempt}
    memory {32.GB * task.attempt}
    time {1.h * task.attempt}
    container "quay.io/biocontainers/subread:2.0.1--hed695b0_0"
    tag "$sample"

    errorStrategy { task.exitStatus == 140 ? 'retry' : 'terminate' }
    maxRetries 3

    input:
    tuple val(sample), path(bam)
    path(gtf)

    output:
    // tuple val(sample), path(counts)
    path(counts)
    path(fc_log)

    script:
    counts = "${sample}_counts.txt"
    fc_log = "${sample}_fc.txt.summary"
    """
    featureCounts \
        -a $gtf \
        -g gene_id \
        -M \
        -p \
        -T $task.cpus \
        -o ${sample}_fc.txt \
        $bam

    printf "Geneid\t${sample}\n" > $counts
    cat ${sample}_fc.txt | cut -f1,7 | sed '1,2d' >> $counts

    """
    // The final two bash commands here are used to get the fc output in a nice
    // format to combine in the next step. First creates the header column in
    // and then pulls out the GeneID and counts column from the featureCounts
    // output. 


}
