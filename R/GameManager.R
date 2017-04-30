library('data.table')
require(data.table)

specToColor <- fread('data/SpecToColor.tsv')

loadAllCards <- function() {
  allCardData <- rbind(fread("data/Neutral.tsv"), fread("data/Red.tsv"), fread("data/Green.tsv"), fread("data/Black.tsv"), fread("data/Blue.tsv"), fread("data/White.tsv"), fread("data/Purple.tsv"), fread("data/Heroes.tsv"), fill = TRUE)
  allCardData$current_zone = allCardData$starting_zone
  allCardData
}

dealCardRandomly <- function(selectedPlayer, currentGame) {
  targettedRows <- which(currentGame$player == selectedPlayer & currentGame$current_zone == 'deck')
  randomRow <- floor(runif(1, min=1, max=nrow(currentGame[targettedRows]) + 1))
  currentGame[targettedRows[randomRow]]$current_zone <- 'hand'
  currentGame
}

getBaseColorFromSpec<- function(playerSpec) {
  specToColor$Color[which(specToColor$Spec == playerSpec)]
}

initBoardForOneVsOneGame <- function(playerOneSpec, playerTwoSpec, allCardData) {
  starter1 <- allCardData[which(allCardData$starting_zone == 'deck' & allCardData$color == getBaseColorFromSpec(playerOneSpec))]
  starter2 <- allCardData[which(allCardData$starting_zone == 'deck' & allCardData$color == getBaseColorFromSpec(playerTwoSpec))]
  starter1$player = '1'
  starter2$player = '2'
}
