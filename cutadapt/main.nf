process RUN_TRIM_READS {
    cpus 4
    memory "1.G"
    time "15.m"
    container "quay.io/biocontainers/cutadapt:4.1--py310h1425a21_1"
    tag "$sample"

    input:
    tuple val(sample), path(reads)

    output:
    tuple val(sample), path("tr_*")

    script:
    out1 = "tr_${reads[0]}"
    out2 = "tr_${reads[1]}"
    """
    cutadapt \
        -a AGATCGGAAGAG \
        -A AGATCGGAAGAG \
        -j $task.cpus \
        -q 20 \
        -o $out1 \
        -p $out2 \
        -m 15 \
        ${reads[0]} \
        ${reads[1]} 
    """

}