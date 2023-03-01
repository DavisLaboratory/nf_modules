process RUN_STAR_GENOME_GENERATE {
    
    cpus 8
    memory "100.G"
    time "4h"
    container "quay.io/biocontainers/star:2.7.10b--h9ee0642_0"
    storeDir "$params.store_dir"

    input:
    path(genome)
    path(gtf)
    val(ens_ver)
    val(read_len)

    output:
    path(index)

    script:
    index = "star_index_${ens_ver}_${read_len}BP_2.7.10b"
    overhang = read_len - 1
    """
    mkdir -p $index

    STAR --runMode genomeGenerate \
         --runThreadN $task.cpus \
         --genomeDir $index \
         --genomeFastaFiles $genome \
         --sjdbGTFfile $gtf \
         --sjdbOverhang $overhang
    """

}