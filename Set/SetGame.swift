
//  Set.swift
//  Set
//
//  Created by Yacov Uziel on 20/09/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//

import Foundation

public class SetGame {
    
    
    let numOfCardsOnStart = 12
    
    let maxGameBoardCapacity = 24
    
    lazy var deckCapacity =  numOfDifferentColors * numOfDifferentShapes * numOfDifferentShadings * numOfShapes
    
    var scorePlayer = 0
    
    var scoreComputer = 0
    
    let numOfDifferentColors = 3
    let numOfDifferentShapes = 3
    let numOfDifferentShadings = 3
    let numOfShapes = 3
    
    var deck = [Card]()
    
    var cardsOnGameBoard = [Card]()
    
    var selectedCards = [Card]()
    
    enum gameMode {
        case singlePlayer
        case playAgainstComputer
    }
    
    
//    func selectGameMode() -> SetGame.gameMode {
//        <#code#>
//    }
//
//    func startSinglePlayerMode() {
//        <#code#>
//    }
//
//    func startAgainstIphoneMode() {
//        <#code#>
//    }
    
//    func startThinking(forHowLong timeInterval: Int, funcToRunAfterTimerEnds funcToRun: () -> [Int]?) {
//        var timeToThink = Int(arc4random_uniform(60))
//        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//            timeToThink -= 1
//            if timeToThink == 0 {
//                self.makeATurn()
//            }
//        }
//    }
    
//    func stopThinking() {
//        <#code#>
//    }
//
//    func makeATurn() {
//        setOfCards = getASet()
//        if setOfCards != nil {
//            waitAndMakeMove()
//        }
//        else {
//
//        }
//    }
//
//    func waitAndMakeMove() {
//        timeToWait = 2
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//            timeToWait -= 1
//            if timeToWait == 0 {
//                self.makeATurn()
//            }
//        }
    
    
    
    
    
    
    func selectCard(atIndex index: Int) {
        if selectedCards.count == 3 {
            selectedCards.removeAll()
        }
        
        for card in cardsOnGameBoard {
            if card.identifier == index {
                selectedCards.append(card)
            }
        }
    }
    
    func deselectCard(atIndex index: Int) {
        var deleted = false
        for cardIndex in 0..<selectedCards.count where !deleted {
            if selectedCards[cardIndex] == cardsOnGameBoard[index] {
                selectedCards.remove(at: cardIndex)
                deleted = true
            }
        }
    }
    
    func checkForSet() -> Bool {
        if selectedCards.count != 3 {
            return false
        }
        let isMatched = SetGame.checkForSet(firstCard: selectedCards[0], secondCard: selectedCards[1], thirdCard: selectedCards[2])
        if (isMatched) {
            setCardsStateToMatched()
        }
        return isMatched
    }
    
    func setCardsStateToMatched() {
        for selectedCardIndex in 0..<selectedCards.count {
            for gameBoardIndex in 0..<cardsOnGameBoard.count {
                if cardsOnGameBoard[gameBoardIndex].identifier == selectedCards[selectedCardIndex].identifier {
                    cardsOnGameBoard[gameBoardIndex].isMatched = true
                }
            }
        }
    }
    
    public static func checkForSet(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        let numberOfShapeCondition = (haveSameNumberOfShapes(firstCard: firstCard, secondCard: secondCard, thirdCard: thirdCard) || haveThreeDifferentNumberOfShapes(firstCard: firstCard, secondCard: secondCard, thirdCard: thirdCard))
        let shapeCondition = (haveSameShape(firstCard: firstCard, secondCard: secondCard, thirdCard: thirdCard) || haveThreeDifferentShapes(firstCard: firstCard, secondCard: secondCard, thirdCard: thirdCard))
        let colorCondition = (haveSameColor(firstCard: firstCard, secondCard: secondCard, thirdCard: thirdCard) || haveThreeDifferentColors(firstCard: firstCard, secondCard: secondCard, thirdCard: thirdCard))
        let shadingCondition = (haveSameShading(firstCard: firstCard, secondCard: secondCard, thirdCard: thirdCard) || haveThreeDifferentShadings(firstCard: firstCard, secondCard: secondCard, thirdCard: thirdCard))
        
        return numberOfShapeCondition && shapeCondition && colorCondition && shadingCondition
    }
    
    static func haveSameNumberOfShapes(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        return firstCard.numOfShapes == secondCard.numOfShapes && secondCard.numOfShapes == thirdCard.numOfShapes
    }
    
    static func haveThreeDifferentNumberOfShapes(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        return
            firstCard.numOfShapes != secondCard.numOfShapes
            && firstCard.numOfShapes != thirdCard.numOfShapes
            && secondCard.numOfShapes != thirdCard.numOfShapes
    }
    
    static func haveSameShape(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        return firstCard.shape == secondCard.shape && secondCard.shape == thirdCard.shape
    }
    
    static func haveThreeDifferentShapes(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        return
                firstCard.shape != secondCard.shape
                && firstCard.shape != thirdCard.shape
                && secondCard.shape != thirdCard.shape
    }
    
    static func haveSameShading(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        return firstCard.shading == secondCard.shading && secondCard.shading == thirdCard.shading
    }

    static func haveThreeDifferentShadings(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        return
                firstCard.shading != secondCard.shading
                && firstCard.shading != thirdCard.shading
                && secondCard.shading != thirdCard.shading
    }
    
    static func haveSameColor(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        return firstCard.color == secondCard.color && secondCard.color == thirdCard.color
    }
    
    static func haveThreeDifferentColors(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        return
                firstCard.color != secondCard.color
                && firstCard.color != thirdCard.color
                && secondCard.color != thirdCard.color
    }
    
    func dealOneCard() -> Card? {
        return deck.popLast() ?? nil
    }
    
    func dealThreeNewCards() -> [Card]{
        if deck.count >= 3 { // have sufficient cards in the deck to deal
            let firstCardFromDeck = deck.popLast()!
            let secondCardFromDeck = deck.popLast()!
            let thirdCardFromDeck = deck.popLast()!
            return [firstCardFromDeck, secondCardFromDeck, thirdCardFromDeck]
        }
        return [Card]()
    }
    
    func getASet() -> [Int]? {
        for firstIndex in 0..<cardsOnGameBoard.count {
            for secondIndex in 0..<cardsOnGameBoard.count {
                for thirdIndex in 0..<cardsOnGameBoard.count {
                    if firstIndex != secondIndex && secondIndex != thirdIndex && firstIndex != thirdIndex {
                        if (cardsOnGameBoard[firstIndex].isMatched == false && cardsOnGameBoard[secondIndex].isMatched == false && cardsOnGameBoard[thirdIndex].isMatched == false) {
                            if SetGame.checkForSet(firstCard: cardsOnGameBoard[firstIndex], secondCard: cardsOnGameBoard[secondIndex], thirdCard: cardsOnGameBoard[thirdIndex]) {
                                return [cardsOnGameBoard[firstIndex].identifier, cardsOnGameBoard[secondIndex].identifier, cardsOnGameBoard[thirdIndex].identifier]

                            }
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func exitGame() {
        exit(0)
    }
    
    init() {
        // Init Deck
        for shapeIndex in 0..<numOfDifferentShapes {
            for colorIndex in 0..<numOfDifferentColors {
                for shadingIndex in 0..<numOfDifferentShadings {
                    for numOfShapesIndex in 0..<numOfShapes {
                        deck.append(Card(shape: shapeIndex, color: colorIndex, shading: shadingIndex, numOfShapes: numOfShapesIndex))
                    }
                }
            }
        }
        
        //shuffle Deck
        for _ in 1...deckCapacity {
            let firstRandomIndex = Int(arc4random_uniform(UInt32(deckCapacity)))
            let secondRandomIndex = Int(arc4random_uniform(UInt32(deckCapacity)))
            deck.swapAt(firstRandomIndex, secondRandomIndex)
        }
    }
}
