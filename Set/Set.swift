//
//  Set.swift
//  Set
//
//  Created by Yacov Uziel on 20/09/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//

import Foundation

class Set {
    
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
//        var setFound = false
        selectedCards.append(cardsOnGameBoard[index])
//        if (selectedCards.count == 3) {
//            setFound = checkForSet()
//            selectedCards.removeAll()
//        }
//        return setFound
    }
    
    
    func checkForSet() -> Bool {
        if (selectedCards.count != 3) {
            return false
        }
        return checkForSet(first: selectedCards[0], second: selectedCards[1], third: selectedCards[2])
    }
    
    func checkForSet(first: Card, second: Card, third: Card) -> Bool {
        var setFound = false
        
        if (haveSameNumberOfShapes(first: first, second: second, third: third) || haveThreeDifferentNumberOfShapes(first: first, second: second, third: third)) && (haveSameShape(first: first, second: second, third: third) || haveThreeDifferentShapes(first: first, second: second, third: third)) && (haveSameColor(first: first, second: second, third: third) || haveThreeDifferentColors(first: first, second: second, third: third)) {
            for cardIndex in selectedCards.indices {
                selectedCards[cardIndex].isMatched = true
            }
            setFound = true
        }
        return setFound
    }
    
//    func selectedCardsAreNotMatchedYet (first: Card, second: Card, third: Card) -> Bool {
//        for card in selectedCards {
//            if card.isMatched == true {
//                return false
//            }
//        }
//        return true
//    }
    
    func haveSameNumberOfShapes(first: Card, second: Card, third: Card) -> Bool {
        return first.numOfShapes == second.numOfShapes && second.numOfShapes == third.numOfShapes
    }
    
    func haveThreeDifferentNumberOfShapes(first: Card, second: Card, third: Card) -> Bool {
        return first.numOfShapes != second.numOfShapes && second.numOfShapes != third.numOfShapes
    }
    
    func haveSameShape(first: Card, second: Card, third: Card) -> Bool {
        return first.shape == second.shape && second.shape == third.shape
    }
    
    func haveThreeDifferentShapes(first: Card, second: Card, third: Card) -> Bool {
        return first.shape != second.shape && second.shape != third.shape
    }
    
    func haveSameShading(first: Card, second: Card, third: Card) -> Bool {
        return first.shading == second.shape && second.shape == third.shading
    }

    func haveThreeDifferentShadings(first: Card, second: Card, third: Card) -> Bool {
        return first.shading != second.shape && second.shape != third.shading
    }
    
    func haveSameColor(first: Card, second: Card, third: Card) -> Bool {
        return first.color == second.color && second.color == third.color
    }
    
    func haveThreeDifferentColors(first: Card, second: Card, third: Card) -> Bool {
        return first.color != second.color && second.color != third.color
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
