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
    
    var score = 0
    
    var cards = [Card]()
    
    private(set) var selectedCards = [Card]()
    
    private var alreadyMatchedCard = [Card]()
    
    func selectCard(atIndex index: Int) {
        selectedCards.append(cards[index])
        if (selectedCards.count == 3) {
            checkForSet()
            selectedCards.removeAll()
        }
    }
    
    func checkForSet() {
        
    }
    
    func dealThreeNewCards() {
        
    }
    
    init() {
        
        
        for colorIndex in colors.indices {
            let color = colors[colorIndex]
            for shapeIndex in shapes.indices {
                let shape = shapes[shapeIndex]
                for fillingIndex in filling.indices {
                    let fillingType = filling[fillingIndex]
                    let card = Card(shape: shape, color: color, filling: fillingType)
                    game.Cards.append(card)
                }
            }
        }
        for _ in 1...numOfCardsOnStart {
            cards.append(Card())
        }
    }
}
