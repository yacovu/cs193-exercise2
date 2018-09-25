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
    private var freeButtons  = [UIButton]()
    private var needToDealNewCards = false
    
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
    
    
//    private enum colors {
//        case Red
//        case Green
//        case Blue
//    }
    
    

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

    @IBAction func showHint(_ sender: UIButton) {
        showHint()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        if game.deck.count >= 3 { // have sufficient cards in the deck to deal
            if matchedButtons.count == 3 { // replace 3 matched cards with 3 new ones from the deck
                for button in matchedButtons {
                    if let cardToAddToGameBoard = game.dealOneCard() {
                        game.cardsOnGameBoard.append(cardToAddToGameBoard)
                        button.setAttributedTitle(NSAttributedString(string: printShape(ofShape: shapeToShading[shapes[cardToAddToGameBoard.shape]]![cardToAddToGameBoard.shading].string, times: cardToAddToGameBoard.numOfShapes + 1), attributes: [NSAttributedStringKey.foregroundColor : getColor(forCard: cardToAddToGameBoard)]), for: UIControlState.normal)
                        changeShape(ofButton: button)
                    }
                    else { //deck is empty
                        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                        sender.isEnabled = false
                    }
                }
            }
            else {
                if game.cardsOnGameBoard.count <= game.maxGameBoardCapacity + 3 { // add 3 new cards to new places
                    for _ in 1...3 {
                        if let cardToAddToGameBoard = game.dealOneCard() {
                            game.cardsOnGameBoard.append(cardToAddToGameBoard)
                            let freeButton = freeButtons[0]
                            freeButton.setAttributedTitle(NSAttributedString(string: printShape(ofShape: shapeToShading[shapes[cardToAddToGameBoard.shape]]![cardToAddToGameBoard.shading].string, times: cardToAddToGameBoard.numOfShapes + 1), attributes: [NSAttributedStringKey.foregroundColor : getColor(forCard: cardToAddToGameBoard)]), for: UIControlState.normal)
                            freeButtons = Array(freeButtons.dropFirst())
                        }
                    }
                }
                else { // gameboard capacity reached to its max. Game over
                    
                }
            }
            updateUI()
        }
        else { // insufficient cards in the deck. The button is disabled
            sender.isEnabled = false
        }
    }
    

    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var deckLabel: UILabel!
    
    @IBAction func touchCard(_ sender: UIButton) {
        var setFound = false
        if let touchedCardIndex = buttons.index(of: sender) {
            if needToDealNewCards { // a set was found and now a new card was selected
                dealNewCard()
            }
            game.selectCard(atIndex: touchedCardIndex)
            changeShape(ofButton: sender)
            if selectedButtons.count == 3 {
                setFound = game.checkForSet()
                if setFound {
                    changeCardsShapeToSet()
                    addButtonsToMatchedButtonsArray()
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
    
    func endGame() {
        let alert = UIAlertController(title: "Game Over", message: "No Further Moves!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.default, handler: {action in self.game.exitGame()}))
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: {action in self.newGame(UIButton())}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showHint() {
        if let threeSetCards = game.getASet() {
            print (threeSetCards)
            for button in buttons {
                if threeSetCards.contains(button.tag) {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                    button.layer.cornerRadius = 8.0
                }
            }
        }
        else {
            let alert = UIAlertController(title: "", message: "No available set on the board", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Deal 3 More Cards", style: UIAlertActionStyle.default, handler: {action in self.dealCards(UIButton())}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func dealNewCard() {
        for button in matchedButtons {
            if let cardToAddToGameBoard = game.dealOneCard() {
                button.setAttributedTitle(NSAttributedString(string: printShape(ofShape: shapeToShading[shapes[cardToAddToGameBoard.shape]]![cardToAddToGameBoard.shading].string, times: cardToAddToGameBoard.numOfShapes + 1), attributes: [NSAttributedStringKey.foregroundColor : getColor(forCard: cardToAddToGameBoard)]), for: UIControlState.normal)
                changeShape(ofButton: button)
            }
        }
        updateUI()
    }
    
    func addButtonsToMatchedButtonsArray() {
        for buttonIndex in 0..<selectedButtons.count {
            matchedButtons.append(selectedButtons[buttonIndex])
        }
        needToDealNewCards = true
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(game.score)"
        deckLabel.text = "Cards in Deck: \(game.deck.count)"
    }
    
    func changeCardsShapeToSet() {
        for button in selectedButtons {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            button.layer.cornerRadius = 8.0
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
            buttons[cardIndex].tag = card.identifier
        }
        freeButtons = Array(buttons.dropFirst(12))
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
        if button.layer.borderColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) || button.layer.borderColor == #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1){
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            button.layer.cornerRadius = 8.0
            selectedButtons.append(button)
        }
        else {
            button.layer.borderWidth = 0
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.cornerRadius = 0
            selectedButtons = selectedButtons.filter {$0 != button}
        }
    }



}

