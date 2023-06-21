process RUN_SUMMARIZED_EXPERIMENT {
    
    cpus 1
    memory "24.G"
    time "30.m"
    // container "quay.io/foo/bar:tag"
    module "R/4.2"
    publishDir "results/${params.project}", mode: 'copy'

    input:
    path(counts)
    path(samplesheet)
    path(gtf)

    output:
    path(SE)

    script:
    SE = "${params.project}_SE.rds"
    """
    makeSE.R -c ${counts} -s ${samplesheet} -g ${gtf}
    """

}