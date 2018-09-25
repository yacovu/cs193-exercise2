//
//  SetTests.swift
//  SetTests
//
//  Created by Yacov Uziel on 25/09/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//

import XCTest
import SetGame

class SetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSameShapeIsMatched() {
        let card1 = Card(shape: 1, color: 0, shading: 0, numOfShapes: 0)
        let card2 = Card(shape: 1, color: 1, shading: 1, numOfShapes: 1)
        let card3 = Card(shape: 1, color: 2, shading: 2, numOfShapes: 2)
        XCTAssertTrue(SetGame.checkForSet(firstCard: card1, secondCard: card2, thirdCard: card3))
    }
    
    func testOneShapeDifferentNotMatched() {
        let card1 = Card(shape: 1, color: 0, shading: 0, numOfShapes: 0)
        let card2 = Card(shape: 0, color: 1, shading: 1, numOfShapes: 1)
        let card3 = Card(shape: 1, color: 2, shading: 2, numOfShapes: 2)
        XCTAssertFalse(SetGame.checkForSet(firstCard: card1, secondCard: card2, thirdCard: card3))
    }
    
    func testSameColorIsMatched() {
        let card1 = Card(shape: 1, color: 1, shading: 0, numOfShapes: 0)
        let card2 = Card(shape: 0, color: 1, shading: 1, numOfShapes: 1)
        let card3 = Card(shape: 2, color: 1, shading: 2, numOfShapes: 2)
        XCTAssertTrue(SetGame.checkForSet(firstCard: card1, secondCard: card2, thirdCard: card3))
    }
    
    func testOneColorDifferentNotMatched() {
        let card1 = Card(shape: 1, color: 1, shading: 0, numOfShapes: 0)
        let card2 = Card(shape: 0, color: 0, shading: 1, numOfShapes: 1)
        let card3 = Card(shape: 2, color: 1, shading: 2, numOfShapes: 2)
        XCTAssertFalse(SetGame.checkForSet(firstCard: card1, secondCard: card2, thirdCard: card3))
    }
    
    func testSameShadingIsMatched() {
        let card1 = Card(shape: 1, color: 1, shading: 2, numOfShapes: 0)
        let card2 = Card(shape: 0, color: 2, shading: 2, numOfShapes: 1)
        let card3 = Card(shape: 2, color: 0, shading: 2, numOfShapes: 2)
        XCTAssertTrue(SetGame.checkForSet(firstCard: card1, secondCard: card2, thirdCard: card3))
    }
    
    func testOneShadingDifferentNotMatched() {
        let card1 = Card(shape: 1, color: 1, shading: 2, numOfShapes: 0)
        let card2 = Card(shape: 0, color: 2, shading: 1, numOfShapes: 1)
        let card3 = Card(shape: 2, color: 0, shading: 2, numOfShapes: 2)
        XCTAssertFalse(SetGame.checkForSet(firstCard: card1, secondCard: card2, thirdCard: card3))
    }
    
    func testSameNumOfShapesIsMatched() {
        let card1 = Card(shape: 1, color: 1, shading: 2, numOfShapes: 0)
        let card2 = Card(shape: 0, color: 2, shading: 1, numOfShapes: 0)
        let card3 = Card(shape: 2, color: 0, shading: 0, numOfShapes: 0)
        XCTAssertTrue(SetGame.checkForSet(firstCard: card1, secondCard: card2, thirdCard: card3))
    }
    
    func testOneNumOfShapesDifferentNotMatched() {
        let card1 = Card(shape: 1, color: 1, shading: 2, numOfShapes: 0)
        let card2 = Card(shape: 0, color: 2, shading: 1, numOfShapes: 1)
        let card3 = Card(shape: 2, color: 0, shading: 0, numOfShapes: 0)
        XCTAssertFalse(SetGame.checkForSet(firstCard: card1, secondCard: card2, thirdCard: card3))
    }
    
}
