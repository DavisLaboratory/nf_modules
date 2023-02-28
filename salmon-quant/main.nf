process RUN_SALMON_QUANT {
    cpus 4
    memory "8.G"
    time "30.m"
    container "combinelab/salmon:1.10.0"
    tag "$sample"
    publishDir "results/salmon", mode: 'symlink', saveAs: { filename -> "${sample}_$filename" }


    input:
    tuple val(sample), path(reads)
    path(salmon_idx)

    output:
        path(output)
    

    script:
    output= "quant"
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