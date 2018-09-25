//
//  Set.swift
//  Set
//
//  Created by Yacov Uziel on 20/09/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//

import Foundation

public class SetGame {
    
    let numOfCardsOnStart = 12
    
    let deckCapacity = 81
    
    var score = 0
    
    let numOfDifferentColors = 3
    let numOfDifferentShapes = 3
    let numOfDifferentShadings = 3
    let numOfShapes = 3
    
    var deck = [Card]()
    
    var cardsOnGameBoard = [Card]()
    
    var selectedCards = [Card]()
    
    private var alreadyMatchedCard = [Card]()
    
    func selectCard(atIndex index: Int) {
        selectedCards.append(cardsOnGameBoard[index])
    }
    
    func checkForSet() -> Bool {
        if (selectedCards.count != 3) {
            return false
        }
        let isMatched = SetGame.checkForSet(firstCard: selectedCards[0], secondCard: selectedCards[1], thirdCard: selectedCards[2])
        if (isMatched) {
            selectedCards[0].isMatched = true
            selectedCards[1].isMatched = true
            selectedCards[2].isMatched = true
        }
        return isMatched
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
        return firstCard.shading == secondCard.shading && secondCard.shape == thirdCard.shading
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
    
    func dealThreeNewCards() {
        
    }
    
    init() {
        
        // init deck
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
        
//        // init gameboard
//        for _ in 0..<numOfCardsOnStart {
//            let cardIndex = Int(arc4random_uniform(UInt32(deck.count)))
//            cardsOnGameBoard.append(deck[cardIndex])
//            deck.remove(at: cardIndex)
//        }
    }
}