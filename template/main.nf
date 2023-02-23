process RUN_XXX {
    
    cpus 1
    memory "1.G"
    time "30.m"
    container "quay.io/foo/bar:tag"

    input:
    tuple val(sample), path(reads)

    output:
    tuple val(sample), path("tr_*")

    script:
    foo=bar
    """
    XXX ${reads}
    """

}