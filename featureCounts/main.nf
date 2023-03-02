process RUN_FEATURECOUNTS {
    
    cpus 4
    memory "32.G"
    time "30.m"
    container "quay.io/repository/biocontainers/subread:2.0.1--hed695b0_0"

    input:
    tuple val(sample), path(bam)
    path(gtf)

    output:
    tuple val(sample), path(counts)
    // path(fc_log)

    script:
    counts = "${sample}_fc.txt"
    // fc_log = 
    """
    featureCounts \
        -a $gtf \
        -g gene_id \
        -p \
        -T $task.cpus \
        -o $counts \
        $bam
    """

}