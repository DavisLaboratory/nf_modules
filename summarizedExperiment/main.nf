process RUN_SUMMARIZED_EXPERIMENT {
    
    cpus 1
    memory "1.G"
    time "30.m"
    container "quay.io/foo/bar:tag"

    input:
    path(counts)
    path(gtf)
    path(samplesheet)

    output:
    path(SE)

    script:
    """
    makeSE.R ${counts} ${gtf} ${samplesheet}
    """

}