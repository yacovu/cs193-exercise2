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
    
    private(set) var deck = [Card]()
    
    private(set) var cardsOnGameBoard = [Card]()
    
    var selectedCards = [Card]()
    
    private(set) var colors = ["red", "green", "blue"]
    private(set) var shading = ["blank","semiFilled","fullyFilled"]
    private(set) var numberOfShapes = [1,2,3]
    lazy private(set) var shapes = ["diamond", "square", "circle"]
    
    private let blankDiamond = NSAttributedString(string: "\u{25CA}")
    private let blankSquare = NSAttributedString(string: "\u{25A2}")
    private let blankCircle = NSAttributedString(string: "\u{25EF}")
    
    private let semiFilledDiamond = NSAttributedString(string: "\u{25C8}")
    private let semiFilledSquare = NSAttributedString(string: "\u{25A3}")
    private let semiFilledCircle = NSAttributedString(string: "\u{25C9}")
    
    private let fullyDiamond = NSAttributedString(string: "\u{25C6}")
    private let fullySquare = NSAttributedString(string: "\u{25A0}")
    private let fullyCircle = NSAttributedString(string: "\u{25CF}")
    
    lazy var shapeToShading = ["diamond":[blankDiamond, semiFilledDiamond, fullyDiamond],
                               "square": [blankSquare, semiFilledSquare, fullySquare],
                               "circle": [blankCircle, semiFilledCircle, fullyCircle]]
    
    
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
    
//    func selectedCardsAreNotMatchedYet (first: Card, second: Card, third: Card) -> Bool {
//        for card in selectedCards {
//            if card.isMatched == true {
//                return false
//            }
//        }
//        return true
//    }
    
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
        for _ in 1...deckCapacity {
            let randomColorIndex = Int(arc4random_uniform(UInt32(colors.count)))
            let randomShapeIndex = Int(arc4random_uniform(UInt32(shapeToShading.keys.count)))
            let shapeName = Array(shapeToShading.keys)[randomShapeIndex]
            let shadingArray = shapeToShading[shapeName]
            let randomShadingIndex = Int(arc4random_uniform(UInt32(shadingArray!.count)))
            let randomNumOfShapes = Int(arc4random_uniform(UInt32(numberOfShapes.count)) + 1)
            deck.append(Card(shape: randomShapeIndex, color: randomColorIndex, shading: randomShadingIndex, numOfShapes: randomNumOfShapes))
        }
        
        // init gameboard
        for _ in 0..<numOfCardsOnStart {
            let cardIndex = Int(arc4random_uniform(UInt32(deck.count)))
            cardsOnGameBoard.append(deck[cardIndex])
            deck.remove(at: cardIndex)
        }
    }
}
