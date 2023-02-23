process RUN_FASTQC {
    cpus 2
    memory "2.G"
    time {"30.m" * task.attempt}
    container "quay.io/biocontainers/fastqc:0.11.9--0"
    tag "$sample"


    // https://www.nextflow.io/docs/latest/process.html?highlight=retry#dynamic-computing-resources 
    errorStrategy { task.exitStatus in 137..140 ? 'retry' : 'terminate' }
    maxRetries 3
    

    input:
    tuple val(sample), path(reads) // 


    output:
    path(output)
    // tuple val(sample), path(output) 


    script:
    output = "${sample}_fastqc"
    """
    mkdir -p $output
    fastqc -o $output -t $task.cpus $reads
    """
}
