library('data.table')
require(data.table)

allCardData <- rbind(rbind(fread("data/Neutral.tsv"), fread("data/Red.tsv"), fread("data/Green.tsv"), fread("data/Black.tsv"), fread("data/Blue.tsv"), fread("data/White.tsv")), fread("data/Purple.tsv"), fill = TRUE)
