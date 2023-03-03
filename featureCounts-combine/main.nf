process RUN_FEATURECOUNTS_COMBINE {
    
    cpus 1
    memory "16.G"
    time "10.m"
    publishDir "results/${params.project}", mode: 'copy'

    input:
    path(counts)

    output:
    path(count_table)

    script:
    count_table = "${params.project}_counts.txt"
    """
    # Get the gene IDs 
    cut -f1 ${counts[0]} > ensg.txt

    # store the counts without IDs in a tmp file for each
    for file in $counts; do
        cut -f2 $file > ${file}.tmp
    done

    # put them all into a single file
    paste ensg.txt ${counts}.tmp > $count_table
    """

}