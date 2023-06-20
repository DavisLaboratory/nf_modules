#! /usr/bin/Rscript

# Sam Lee
# @samleenz

library(rtracklayer)
library(SummarizedExperiment)


#' Read nextflow config file
#' 
#' Read a nextflow config file to a two column tibble
#'
#' @param file: as for `readr::read_lines()`
#'
#' @return A two column tibble with column `parameter` and column `value`
#' @export
#'
#' @examples 
read_nf_config <- function(file){
  stopifnot("file must be a .config" = stringr::str_ends(file, "\\.config"))
  
  
  raw <- readr::read_lines(file) |>
    stringr::str_remove("^\\s*") |>        # leading whitespace
    stringr::str_remove("^\\/\\/\\s.*") |> # leading comments
    stringr::str_remove("\\/\\/.*$") |>    # trailing comments
    stringr::str_remove("\\s*$") |>        # trailing whitespace
    stringr::str_remove_all('\\"') |>      # inline quotation marks
    stringr::str_subset("=")               # keep only lines that have params
  
  
  tidied <- raw |>
    as_tibble() |>
    separate(value, c("parameter", "value"), sep = " = ")
  
  return(tidied)
}

# args to set
nf_dir <- "/vast/projects/ncla/nf_merino_lego"
param_file <- "params.config"
sample_annotation_file <- "sample_annotation.csv"


# load nextflow parameters
nf_parameters <- read_nf_config(file.path(nf_dir, param_file))
nf_parameters_lst <- setNames(nf_parameters$value, nf_parameters$parameter)
  
# read in sample data 
annot <- read.csv(
    file.path(nf_dir, sample_annotation_file), stringsAsFactors = FALSE
    )

# read in count data
proj <- nf_parameters_lst['project']


counts <- read.delim(
    file.path(nf_dir, "results", proj, paste(proj, "counts.txt", sep = "_")),
    stringsAsFactors = FALSE,
    row.names = "Geneid"
    )


stopifnot(
  "Sample names do not match" = all(colnames(counts) %in% rownames(annot))
  )

2-2
# read gene annotations
gene_annotations <- rtracklayer::import(nf_parameters_lst['gtf']) |>
as.data.frame()

cols_keep <- setdiff(
    colnames(gene_annotations), 
    c(
      "score", "phase", "tag", "ccds_id",
      colnames(gene_annotations)[startwsWith(colnames(gene_annotations), "exon")],
      colnames(gene_annotations)[startwsWith(colnames(gene_annotations), "transcript")],
      colnames(gene_annotations)[startwsWith(colnames(gene_annotations), "protein")]
      )
    )

# drop rows with duplicate gene_id (base R)
gene_annotations <- gene_annotations[!duplicated(gene_annotations$gene_id), cols_keep]

rownames(gene_annotations) <- gene_annotations$gene_id
gene_annotations$gene_id <- NULL

stopifnot(
  "gene IDs do not match" = all(rownames(counts) %in% rownames(gene_annotations2))
  )

  ## create SummarizedExperiment object
se <- SummarizedExperiment(
    assays = list(counts = counts),
    colData = annot,
    rowData = gene_annotations
    )


saveRDS(mySE, file = paste(proj, "SE.rds", sep = "_"))