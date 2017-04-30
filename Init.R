library('data.table')
require(data.table)
source("R/GameManager.R")

#load all card data
allCardData <- loadAllCards()

#make the starter deck for Bashing and Finesse
currentGame <- initBoardForOneVsOneGame('Bashing', 'Finesse', allCardData)
currentGame <- dealFirstFiveCardsToPlayers(currentGame)
