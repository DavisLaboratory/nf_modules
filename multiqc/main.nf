process RUN_MULTIQC {
    cpus 1
    memory "2.G"
    time "30.m"
    container "quay.io/biocontainers/multiqc:1.14--pyhdfd78af_0"
    publishDir "results/${params.project}", mode: 'copy' 
    // default mode would be tosymlink the files
    
    

    input:
    path(dirs) // list of fastqc dirs


    output:
    path("${output}/*")
    // tuple val(sample), path(output) 


    script:
    output = "multiqc"
    // output_1="fastqc_reports/${sample}_1_fastqc.zip"
    """
    mkdir -p $output
    multiqc -f -o $output $dirs
    """
}
