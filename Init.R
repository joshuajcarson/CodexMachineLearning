library('data.table')
require(data.table)
source("R/GameManager.R")

#load all card data
allCardData <- loadAllCards()

#make the starter deck for Bashing and Finesse
neutralStarterDeck <- allCardData[which(allCardData$starting_zone == 'deck' & allCardData$color == 'Neutral')]
starter1 <- neutralStarterDeck
starter2 <- neutralStarterDeck
starter1$player = '1'
starter2$player = '2'
currentGame <- rbind(starter1, starter2)
rm(neutralStarterDeck, starter1, starter2)

#Setup the 'currentGame' zone which will have the current state of the game at all times
#TODO actually deal out cards instead of just putting one card to the hand of one of the players
currentGame$current_zone = currentGame$starting_zone
