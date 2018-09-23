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
    
    var deck = [Card]()
    
    var cardsOnGameBoard = [Card]()
    
    private(set) var selectedCards = [Card]()
    
    private var alreadyMatchedCard = [Card]()
    
    func selectCard(atIndex index: Int) {
        selectedCards.append(deck[index])
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
        for _ in 1...deckCapacity {
            deck.append(Card())
        }
        
//        for _ in 1...numOfCardsOnStart {
//
//        }
    }
}
