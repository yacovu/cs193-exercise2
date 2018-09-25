//
//  ViewController.swift
//  Set
//
//  Created by Yacov Uziel on 20/09/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let game = SetGame()
    private var selectedButtons = [UIButton]()
    private var matchedButtons = [UIButton]()
    
    private var setFound = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var buttons: [UIButton]! {
        didSet {
//            initDeck()
            initGameBoard()
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func touchCard(_ sender: UIButton) {
        var setFound = false
        if let touchedCardIndex = buttons.index(of: sender) {
            game.selectCard(atIndex: touchedCardIndex)
            changeShape(ofButton: sender)
            if selectedButtons.count == 3 {
                setFound = game.checkForSet()
                changeCardsShape(setFound: setFound)
            }
            updateUI()
        }
        
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(game.score)"
        
    }
    
    func changeCardsShape(setFound found: Bool) {
        if found {
            for button in selectedButtons {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                button.layer.cornerRadius = 8.0
                matchedButtons = selectedButtons
            }
        }
        else {
            for button in selectedButtons {
                button.layer.borderWidth = 0
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.layer.cornerRadius = 0
            }
        }
        selectedButtons.removeAll()
    }
    
//    func changeCardToOriginalShape() {
//        for button in buttons {
//            button.layer.borderWidth = 0
//            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            button.layer.cornerRadius = 0
//        }
//    }
    
    func initGameBoard() {
        for cardIndex in 0..<game.numOfCardsOnStart {
            let card = game.cardsOnGameBoard[cardIndex]
            let shape = game.shapes[card.shape]
            let shade = game.shapeToShading[shape]![card.shading]
            let foregroundColor = getColor(forCard: card)
            buttons[cardIndex].setAttributedTitle(NSAttributedString(string: printShape(ofShape: shade.string, times: card.numOfShapes), attributes: [NSAttributedStringKey.foregroundColor : foregroundColor]), for: UIControlState.normal)
        }
    }
    
        //TODO: change from switch case
    func getColor (forCard card: Card) ->  UIColor{
        let color = game.colors[card.color]
        switch color {
            case "red":
                return UIColor.red
            case "green":
                return UIColor.green
            default: return UIColor.blue
        }
    }
    

    func printShape(ofShape shape: String, times numOfTimes: Int) -> String {
        var shapeToPrint = ""
        for _ in 1...numOfTimes {
            shapeToPrint += shape
        }
        return shapeToPrint
    }
    
    func changeShape(ofButton button: UIButton) {
        if button.layer.borderWidth == 3.0 {
            button.layer.borderWidth = 0
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.cornerRadius = 0
            selectedButtons = selectedButtons.filter {$0 != button}
//            numOfSelectedCards -= 1
        }
        else {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            button.layer.cornerRadius = 8.0
            selectedButtons.append(button)
//            numOfSelectedCards += 1
        }
    }
    
//    var cardProperties = [Int:[Int]]()
    
    //returns color, shape, shading and number of shapes for a specific card
//    func getProperties(forCard card: Card) -> [Int] {
//        
////        if cardProperties[card.identifier] == nil {
////            let cardColor = game.deck[card.identifier].color
////            let cardShape = game.deck[card.identifier].shape
////            let cardShading = game.deck[card.identifier].shading
////            let cardNumOfShapes = game.deck[card.identifier].numOfShapes
////            cardProperties[card.identifier] = [cardColor,cardShape,cardShading,cardNumOfShapes]
////        }
////        return cardProperties[card.identifier] ?? [-1, -1, -1, -1]
//    }



}

