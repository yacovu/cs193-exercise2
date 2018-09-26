//
//  ViewController.swift
//  Set
//
//  Created by Yacov Uziel on 20/09/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    private var selectedButtons = [UIButton]()
    private var matchedButtons = [UIButton]()
    private var needToDealNewCards = false
    lazy private var freeButtonIndex =  game.numOfCardsOnStart // the new free button index to add a new card to
    
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
            for button in buttons {
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.tag = -1
            }
            initGameBoard()
        }
    }
    
    @IBAction func showHint(_ sender: UIButton) {
        showHint()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        for button in buttons {
            button.setAttributedTitle(NSAttributedString(string: "", attributes: nil), for: UIControlState.normal)
            button.layer.borderWidth = 0
            button.layer.cornerRadius = 0
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.tag = -1
        }
        initGameBoard()
        game = SetGame()
        freeButtonIndex = game.numOfCardsOnStart
        selectedButtons = [UIButton]()
        matchedButtons = [UIButton]()
        needToDealNewCards = false
        updateUI()
        
        
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        let threeNewCards = game.dealThreeNewCards() // get three new cards from the deck
        if threeNewCards.count == 3 {
            if matchedButtons.count == 3 { // replace 3 matched cards with 3 new ones from the deck
                for matchIndex in 0..<3 { // find the required button in buttons array
                    for buttonIndex in 0..<buttons.count {
                        if buttons[buttonIndex].tag == matchedButtons[matchIndex].tag { // we are on the right button
                            buttons[buttonIndex].setAttributedTitle(NSAttributedString(string: printShape(ofShape: shapeToShading[shapes[threeNewCards[matchIndex].shape]]![threeNewCards[matchIndex].shading].string, times: threeNewCards[matchIndex].numOfShapes + 1), attributes: [NSAttributedStringKey.foregroundColor : getColor(forCard: threeNewCards[matchIndex])]), for: UIControlState.normal)
                            changeShape(ofButton: buttons[buttonIndex])
                            buttons[buttonIndex].tag = threeNewCards[matchIndex].identifier
                            buttons[buttonIndex].isEnabled = true
                        }
                    }
                }
            }
            else if game.cardsOnGameBoard.count <= game.maxGameBoardCapacity - 3 { // add 3 new cards to new places
                for index in 0..<3 {
//                    let freeButtonToAddCardTo = freeButtons[0]
                    buttons[freeButtonIndex].setAttributedTitle(NSAttributedString(string: printShape(ofShape: shapeToShading[shapes[threeNewCards[index].shape]]![threeNewCards[index].shading].string, times: threeNewCards[index].numOfShapes + 1), attributes: [NSAttributedStringKey.foregroundColor : getColor(forCard: threeNewCards[index])]), for: UIControlState.normal)
                    buttons[freeButtonIndex].tag = threeNewCards[index].identifier
                    freeButtonIndex += 1
                    game.cardsOnGameBoard.append(threeNewCards[index])
//                    freeButtons = Array(freeButtons.dropFirst()) // remove the curent button from freeButtons array
                }
            }
            else { // gameboard capacity reached to its max. Game over
                endGame()
            }
        }
        else { // insufficient cards in the deck. The button is disabled
            let alert = UIAlertController(title: "Warning!", message: "Cards in the Deck", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            sender.isEnabled = false // disable the button as required
        }
        if game.cardsOnGameBoard.count == game.maxGameBoardCapacity {
            sender.isEnabled = false
        }
        needToDealNewCards = false
        matchedButtons.removeAll()
        updateUI()
    }
    
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var deckLabel: UILabel!
    
    @IBAction func touchCard(_ sender: UIButton) {
        var setFound = false
        if let touchedCardIndex = buttons.index(of: sender) {
            if needToDealNewCards { // a set was found and now a new card was selected
                dealCards(sender)
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
            for cardIndex in 0..<threeSetCards.count {
                let cardIdentifier = threeSetCards[cardIndex]
                for button in buttons {
                    if button.tag == cardIdentifier {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                        button.layer.cornerRadius = 8.0
                    }
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
    
    func addButtonsToMatchedButtonsArray() {
        matchedButtons.removeAll()
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
            buttons[cardIndex].tag = card.identifier
        }
//        freeButtons = Array(buttons.dropFirst(12))
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
            if selectedButtons.count == 3 {
                selectedButtons.removeAll()
            }
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
