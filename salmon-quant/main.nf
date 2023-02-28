process RUN_SALMON_QUANT {
    cpus 4
    memory "8.G"
    time "30.m"
    container "combinelab/salmon:1.10.0"
    tag "$sample"

    input:
    tuple val(sample), path(reads)
    path(salmon_idx)

    output:
    tuple(
        path("${output}/quant.sf")
        path("${output}/cmd_info.json")
        path("${output}/aux_info")
    )

    script:
    output="quant/${sample}_quant"
    """
    salmon quant \
      -i ${salmon_idx} \
      -l A \
      -1 ${reads[0]} \
      -2 ${reads[1]} \
      -p ${task.cpus} \
      -o ${output}
    """

}