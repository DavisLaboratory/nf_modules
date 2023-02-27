process RUN_SALMON_INDEX {
    cpus 4
    memory "24.G"
    time "2.h"
    container "hub.docker.com/combinelab/salmon:1.10.0"
    storeDir "$params.store_dir"

    input:
    val(tx_ver)
    path(txome)

    output:
    path(idx)

    script:
    idx="salmon_index_${tx_ver}_1.10.0"
    """
    salmon index -t ${txome} -i ${idx}
    """

}