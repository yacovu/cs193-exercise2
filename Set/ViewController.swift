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
                if setFound {
                    changeCardsShapeToSet()
                    disableButtons()
                }
                else {
                    changeCardsShapeToSelected()
                }
                selectedButtons.removeAll()
            }
            updateUI()
        }
        
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(game.score)"
        
    }
    
    func changeCardsShapeToSet() {
        for button in selectedButtons {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            button.layer.cornerRadius = 8.0
            matchedButtons = selectedButtons
        }
    }
    
    func changeCardsShapeToSelected() {
        for button in selectedButtons {
            button.layer.borderWidth = 0
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.cornerRadius = 0
        }
    }
    
    func disableButtons() {
        for button in selectedButtons {
            button.isEnabled = false
        }
    }
    
    func modifyProperty(ofCard card: Card, randomShapeIndex shapeIndex: Int, randomColorIndex colorIndex: Int, randomShadingIndex shadinIndex: Int, randomNumOfShapes numOfShapes: Int ) -> Card {
        return Card(shape: shapeIndex, color: colorIndex, shading: shapeIndex, numOfShapes: numOfShapes)
    }
    
    func initGameBoard() {
        for cardIndex in 0..<game.numOfCardsOnStart {
            game.cardsOnGameBoard.append(game.deck[cardIndex])
            let card = game.cardsOnGameBoard[cardIndex]
            let shape = shapes[card.shape]
            let shade = shapeToShading[shape]![card.shading]
            let foregroundColor = getColor(forCard: card)
            buttons[cardIndex].setAttributedTitle(NSAttributedString(string: printShape(ofShape: shade.string, times: card.numOfShapes + 1), attributes: [NSAttributedStringKey.foregroundColor : foregroundColor]), for: UIControlState.normal)
        }
    }
    
        //TODO: change from switch case
    func getColor (forCard card: Card) ->  UIColor{
        let color = colors[card.color]
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
        }
        else {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            button.layer.cornerRadius = 8.0
            selectedButtons.append(button)
        }
    }



}

