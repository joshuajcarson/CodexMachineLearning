library('data.table')
require(data.table)

#load all card data
allCardData <- rbind(fread("data/Neutral.tsv"), fread("data/Red.tsv"), fread("data/Green.tsv"), fread("data/Black.tsv"), fread("data/Blue.tsv"), fread("data/White.tsv"), fread("data/Purple.tsv"), fread("data/Heroes.tsv"), fill = TRUE)

#make the starter deck for Bashing and Finesse
neutralStarterDeck <- allCardData[which(allCardData$starting_zone == 'deck' & allCardData$color == 'Neutral'),]
starter1 <- neutralStarterDeck
starter2 <- neutralStarterDeck
starter1$player = '1'
starter2$player = '2'
currentGame <- rbind(starter1, starter2)
rm(neutralStarterDeck, starter1, starter2)

#Setup the 'currentGame' zone which will have the current state of the game at all times
#TODO actually deal out cards instead of just putting one card to the hand of one of the players
currentGame$current_zone = currentGame$starting_zone
currentGame$current_zone[currentGame$player=='1'&currentGame$current_zone=='deck'] <- 'deck'

currentGame$current_zone[which(currentGame$player=='1'&currentGame$current_zone=='deck')[2]] <- 'hand'
