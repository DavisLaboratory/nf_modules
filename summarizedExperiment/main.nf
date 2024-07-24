process RUN_SUMMARIZED_EXPERIMENT {
    
    cpus 1
    memory "24.G"
    time "30.m"
    container "samleenz/run_summarized_experiment:v1.1"
    // module "R/4.2"
    publishDir "results/${params.project}", mode: 'copy'

    input:
    path(counts)

    output:
    path(SE)

    script:
    SE = "${params.project}_SE.rds"
    """
    makeSE.R -c ${counts} -s ${params.samplesheet} -g ${params.gtf} -p ${params.project}
    """

}