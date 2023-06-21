#!/usr/bin/env Rscript

# Sam Lee
# @samleenz

library(argparse)
library(rtracklayer)
library(SummarizedExperiment)

parser <- ArgumentParser()

# add arguments
# 1. counts file
# 2. sample annotation file
# 3. GTF file

parser$add_argument(
    "-c", "--counts", 
    help = "counts file", 
    type = "character", 
    required = TRUE
    )

parser$add_argument(
    "-s", "--sample_annotation", 
    help = "sample annotation file", 
    type = "character", 
    required = TRUE
    )

parser$add_argument(
    "-g", "--gtf", 
    help = "gtf file", 
    type = "character", 
    required = TRUE
    )

parser$add_argument(
    "-p", "--project", 
    help = "gtf file", 
    type = "character", 
    required = TRUE
    )

# set args
args <- parser$parse_args()


 
# read in sample data 
annot <- read.csv(
  args$sample_annotation, 
  stringsAsFactors = FALSE,
  row.names = "sample"
  )

# read in count data
counts <- read.delim(
    args$counts,
    stringsAsFactors = FALSE,
    row.names = "Geneid"
    )


stopifnot(
  "Sample names do not match" = all(colnames(counts) %in% rownames(annot))
  )


# read gene annotations
gene_annotations <- rtracklayer::import(args$gtf) |>
    as.data.frame()


# drop rows with duplicate gene_id (base R)
# duplicates are because of transcript / exon records(?)
gene_annotations <- gene_annotations[!duplicated(gene_annotations$gene_id), ]

rownames(gene_annotations) <- gene_annotations$gene_id
gene_annotations$gene_id <- NULL

stopifnot(
  "gene IDs do not match" = all(rownames(counts) %in% rownames(gene_annotations))
  )

# add metadata
meta <- list(
  date_compiled = Sys.Date()
)

## create SummarizedExperiment object
se <- SummarizedExperiment(
    assays = list(counts = counts),
    colData = annot[colnames(counts), ],
    rowData = gene_annotations[rownames(counts), ],
    metadata = meta
    )


saveRDS(se, file = paste(args$project, "SE.rds", sep = "_"))