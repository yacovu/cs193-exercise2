//
//  Card.swift
//  Set
//
//  Created by Yacov Uziel on 20/09/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//

import Foundation

struct Card {
//    private var isSelected: Bool
    private var isMatched: Bool
    private(set) var identifier: Int
    private var shape: Int
    private var color: Int
    private var filling: Int
    
    static var uniqueIdentifier = 0
    
    static func getNextUniqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    init() {
//        seflt.isSelected = false
        self.isMatched = false
        self.identifier = Card.getNextUniqueIdentifier()
        self.shape = -1
        self.color = -1
        self.filling = -1
    }
}
