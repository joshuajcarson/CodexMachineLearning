library('data.table')
require(data.table)

specToColor <- fread('data/SpecToColor.tsv')

loadAllCards <- function() {
  allCardData <- rbind(fread("data/Neutral.tsv"), fread("data/Red.tsv"), fread("data/Green.tsv"), fread("data/Black.tsv"), fread("data/Blue.tsv"), fread("data/White.tsv"), fread("data/Purple.tsv"), fread("data/Heroes.tsv"), fill = TRUE)
  allCardData$current_zone = allCardData$starting_zone
  allCardData
}

dealCardRandomly <- function(selectedPlayer, currentGame, numCards = 1) {
  targettedRows <- which(currentGame$player == selectedPlayer & currentGame$current_zone == 'deck')
  if(length(targettedRows) < numCards) {
    currentGame <- dealCardRandomly(selectedPlayer, currentGame, length(targettedRows))
    currentGame <- shuffleDiscardIntoDeck(selectedPlayer, currentGame)
    newTargettedRows <- which(currentGame$player == selectedPlayer & currentGame$current_zone == 'deck')
    numCardsToDraw <- min(length(newTargettedRows), numCards - length(targettedRows))
    dealCardRandomly(selectedPlayer, currentGame, numCardsToDraw)
  } else {
    currentGame[sample(targettedRows, size=numCards)]$current_zone <- 'hand'
    currentGame
  }
}

shuffleDiscardIntoDeck <- function(selectedPlayer, currentGame) {
  targettedRows <- which(currentGame$player == selectedPlayer & currentGame$current_zone == 'discard')
  currentGame[targettedRows]$current_zone == 'deck'
  currentGame
}

getBaseColorFromSpec <- function(playerSpec) {
  specToColor$Color[which(specToColor$Spec == playerSpec)]
}

getDefaultBuildings <- function(allCardData) {
  techBuildings <- allCardData[which(allCardData$type == 'Tech Building' | allCardData$type == 'Add-on Building')]
  techBuildings[which(techBuildings$name == 'Base')]$current_zone <- 'active'
  techBuildings
}

getCardsIncludingStarterForSpec <- function(playerSpec, allCardData, numOfWorkers) {
  starterDeck <- allCardData[which(allCardData$starting_zone == 'deck' & allCardData$color == getBaseColorFromSpec(playerSpec))]
  starterCodex <- allCardData[which(allCardData$starting_zone == 'codex' & allCardData$spec == playerSpec)]
  starterHero <- allCardData[which(allCardData$type == 'Hero' & allCardData$spec == playerSpec)]
  starterWorkers <- allCardData[which(allCardData$type == 'Worker')[1:numOfWorkers]]
  rbind(starterDeck, starterHero, starterCodex, starterCodex, starterWorkers)
}

initGameState <- function(numPlayers) {
  gameStates <- data.frame(name=character(), starting_zone=character(), current_zone=character(), player=integer(), type=character(), cost=integer(), stringsAsFactors = FALSE)
  for(i in 1:numPlayers) {
    gameStates[nrow(gameStates)+1,] <- c('gold', 'currentGold', 'currentGold', i, 'gameState', 0)
  }
  gameStates[nrow(gameStates)+1,] <- c('currentPlayer', 'currentPlayer', 'currentPlayer', 1, 'gameState', NA)
  gameStates[nrow(gameStates)+1,] <- c('currentTurn', 'currentTurn', 'currentTurn', NA, 'gameState', 1)
  gameStates[nrow(gameStates)+1,] <- c('currentPhase', 'gameStart', 'gameStart', NA, 'gameState', 1)
  gameStates
}

initBoardForOneVsOneGame <- function(playerOneSpec, playerTwoSpec, allCardData) {
  techBuildings <- getDefaultBuildings(allCardData)
  
  starter1 <- rbind(techBuildings, getCardsIncludingStarterForSpec(playerOneSpec, allCardData, 4))
  starter2 <- rbind(techBuildings, getCardsIncludingStarterForSpec(playerTwoSpec, allCardData, 5))
  
  starter1$player = '1'
  starter2$player = '2'
  
  currentGame <- rbind(starter1, starter2, initGameState(2), fill=TRUE)
  currentGame$summoning_sickness = NA
  currentGame
}

#only valid for two player games
dealFirstFiveCardsToPlayers <- function(currentGame) {
  currentGame <- dealCardRandomly(1, currentGame, 5)
  currentGame <- dealCardRandomly(2, currentGame, 5)
}
