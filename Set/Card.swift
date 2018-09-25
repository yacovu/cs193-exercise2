//
//  Card.swift
//  Set
//
//  Created by Yacov Uziel on 20/09/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//

import Foundation

public struct Card {
    var isMatched: Bool
    private(set) var identifier: Int
    var shape: Int
    var color: Int
    var shading: Int
    var numOfShapes: Int
    
    static var uniqueIdentifier = -1
    
    static func getNextUniqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    public init(shape: Int, color: Int, shading: Int, numOfShapes: Int) {
        self.identifier = Card.getNextUniqueIdentifier()
        self.isMatched = false
        self.shape = shape
        self.color = color
        self.shading = shading
        self.numOfShapes = numOfShapes
    }
}
