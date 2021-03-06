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
    private var needToDeselectNotASetSelection = false
    lazy private var freeButtonIndex =  game.numOfCardsOnStart // the new free button index to add a new card to
    
    private var setFound = false
    private var firstTimeDeckEmpty = true
    
    private var needToEndGame = false
    
    private(set) var colors = ["red", "green", "blue"]
    private(set) var shading = ["blank","semiFilled","fullyFilled"]
    private(set) var numberOfShapes = [1,2,3]
    lazy private(set) var shapes = ["diamond", "square", "circle"]
    
    let blankDiamond = NSAttributedString(string: "\u{25CA}")
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
    
    enum colorType: Int {
        case red
        case green
        case blue
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initGameBoard()
        
    }
    
    
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            for button in buttons {
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.tag = -1
            }
        }
    }
    
    @IBAction func showHint(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are You Sure?", message: "Taking a hint will reduce your score by one point. Continue?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {action in self.getAHint()}))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func getAHint() {
        showThreeMatchedCards()
        game.score -= 1
        updateUI()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        let alert = UIAlertController(title: "Starting a New Game", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {action in self.startNewGame()}))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startNewGame() {
        for button in buttons {
            button.setAttributedTitle(NSAttributedString(string: "", attributes: nil), for: UIControlState.normal)
            button.layer.borderWidth = 0
            button.layer.cornerRadius = 0
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.tag = -1
            button.isEnabled = true
            needToEndGame = false
        }
        game = SetGame()
        initGameBoard()
        freeButtonIndex = game.numOfCardsOnStart
        selectedButtons = [UIButton]()
        matchedButtons = [UIButton]()
        needToDealNewCards = false
        dealCard.isEnabled = true //enable deal 3 cards button
        
        updateUI()
    }
    
    @IBOutlet weak var dealCard: UIButton!
    
    @IBAction func dealCardsAndAddToGameBoard(_ sender: UIButton) {
       checkIfNeedToEnd()
        
        let threeNewCards = game.dealThreeNewCards() // get three new cards from the deck
        if threeNewCards.count == 3 {
            if matchedButtons.count == 3 { // replace 3 matched cards with 3 new ones from the deck
                let threeOldIndexes = [matchedButtons[0].tag, matchedButtons[1].tag, matchedButtons[2].tag]
                for matchIndex in 0..<3 { // find the required button in buttons array
                    for buttonIndex in 0..<buttons.count {
                        if buttons[buttonIndex].tag == matchedButtons[matchIndex].tag { // we are on the right button
                            let shade = printShape(ofShape: shapeToShading[shapes[threeNewCards[matchIndex].shape]]![threeNewCards[matchIndex].shading].string, times: threeNewCards[matchIndex].numOfShapes + 1)
                            let attString = NSAttributedString(string: shade, attributes: [NSAttributedStringKey.foregroundColor : getColor(forCard: threeNewCards[matchIndex])])
                            buttons.setButton(atIndex: buttonIndex, tag: threeNewCards[matchIndex].identifier, attributedString: attString, for: UIControlState.normal)
                            changeShape(ofButton: buttons[buttonIndex])
                        }
                    }
                }
                addThreeNewCardsToSamePlaces(threeOldCardsPlaces: threeOldIndexes, threeCardsToAdd: threeNewCards)
            }
            else if game.cardsOnGameBoard.count <= game.maxGameBoardCapacity - 3 { // add 3 new cards to new places
                for index in 0..<3 {
                    let shade = printShape(ofShape: shapeToShading[shapes[threeNewCards[index].shape]]![threeNewCards[index].shading].string, times: threeNewCards[index].numOfShapes + 1)
                    let attString = NSAttributedString(string: shade, attributes: [NSAttributedStringKey.foregroundColor : getColor(forCard: threeNewCards[index])])
                    buttons.setButton(atIndex: freeButtonIndex, tag: threeNewCards[index].identifier, attributedString: attString, for: UIControlState.normal)
                    freeButtonIndex += 1
                }
                addThreeNewCardsToGameBoard(threeCards: threeNewCards)
            }
            else { // gameboard capacity reached to its max. Game over
                needToEndGame = true
            }
        }
        else { // insufficient cards in the deck. The button is disabled
            if firstTimeDeckEmpty {
                let alert = UIAlertController(title: "Warning!", message: "Deck is Empty!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in self.checkIfNeedToEnd()}))
                self.present(alert, animated: true, completion: nil)
                dealCard.isEnabled = false // disable the button as required
                firstTimeDeckEmpty = false
            }
        }

        if game.cardsOnGameBoard.count == game.maxGameBoardCapacity { // insufficient cards in the game board. The button is disabled
            sender.isEnabled = false
        }
        needToDealNewCards = false
        matchedButtons.removeAll()
        updateUI()
    }
    
    func checkIfNeedToEnd() {
        if needToEndGame {
            endGame()
        }
    }

    func removeThreeOldCardsFromGameBoard(locatedAtButtons buttons: [UIButton]) {
        for button in buttons {
            var found = false
            for cardIndex in 0..<game.cardsOnGameBoard.count where !found {
                if game.cardsOnGameBoard[cardIndex].identifier == button.tag {
                    game.cardsOnGameBoard.remove(at: cardIndex)
                    found = true
                }
            }
        }

    }
    
    func addThreeNewCardsToGameBoard(threeCards cardsToAdd: [Card]) {
        for card in cardsToAdd {
            game.cardsOnGameBoard.append(card)
        }
    }
    
    func addThreeNewCardsToSamePlaces(threeOldCardsPlaces: [Int], threeCardsToAdd: [Card]) {
        for buttonIndex in 0..<threeOldCardsPlaces.count {
            for cardIndex in 0..<game.cardsOnGameBoard.count {
                if game.cardsOnGameBoard[cardIndex].identifier == threeOldCardsPlaces[buttonIndex] {
                    game.cardsOnGameBoard[cardIndex] = threeCardsToAdd[buttonIndex]
                }
            }
        }
    }
    
    
    func hideMatchSetFromUI() {
        for button in selectedButtons {
            button.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.0302321743)
            button.layer.borderWidth = 0
            button.layer.cornerRadius = 0
            button.setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
            button.isEnabled = false
        }
        
        for selectedButton in selectedButtons {
            for buttonIndex in 0..<buttons.count {
                if  buttons[buttonIndex] == selectedButton {
                    buttons[buttonIndex].isEnabled = false
                }
            }
        }
    }
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var deckLabel: UILabel!
    
    @IBAction func touchCard(_ sender: UIButton) {
        var setFound = false
        
      checkIfNeedToEnd()
        
        if let touchedCardIndex = buttons.index(of: sender) {
            if isSelected(selectedButton: sender) {
                var deleted = false
                game.deselectCard(atIndex: touchedCardIndex)
                for buttonIndex in 0..<selectedButtons.count where !deleted {
                    if selectedButtons[buttonIndex] == sender {
                        selectedButtons.remove(at: buttonIndex)
                        deleted = true
                    }
                }
            }
            else {
                game.selectCard(atIndex: buttons[touchedCardIndex].tag)
                selectedButtons.append(sender)
            }
            
            if needToDealNewCards { // a set was found and now a new card was selected
                dealCardsAndAddToGameBoard(sender) // get three new cards from the deck and adds them to the game board
                clearButttons()
                needToDealNewCards = false
            }
            if needToDeselectNotASetSelection {
                deselectNotSetButtons()
                needToDeselectNotASetSelection = false
            }
            
            changeShape(ofButton: sender)
            
            if selectedButtons.count == 3 {
                setFound = game.checkForSet()
                if setFound {
                    changeCardsShapeToSet()
                    addButtonsToMatchedButtonsArray()
                    needToDealNewCards = true
                    disableButtons()
                    game.score += 3
                    if game.deck.count == 0 {
                        hideMatchSetFromUI()
                        removeMatchSetFromGameBoard()
                    }
                    if game.cardsOnGameBoard.count == 0 {
                        winGame()
                    }
                }
                else {
                    changeCardsShapeToNotASet()
                    needToDeselectNotASetSelection = true
                    
                    game.score -= 5
                }
                selectedButtons.removeAll()
            }
            updateUI()
        }
    }
    
    func getStyle(ofButton button: UIButton) -> CGColor? {
        return button.layer.borderColor
    }
    
    func removeMatchSetFromGameBoard() {
        for button in selectedButtons {
            var found = false
            for cardIndex in 0..<game.cardsOnGameBoard.count where !found {
                if game.cardsOnGameBoard[cardIndex].identifier == button.tag {
                    game.cardsOnGameBoard.remove(at: cardIndex)
                    found = true
                }
            }
        }
        
    }
    
    
    func winGame() {
        let alert = UIAlertController(title: "Game Over", message: "Congratulations, You Won!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.default, handler: {action in self.game.exitGame()}))
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: {action in self.newGame(UIButton())}))
        self.present(alert, animated: true, completion: nil)
    }
        
        
    func clearButttons() {
        for button in buttons {
            button.layer.borderWidth = 0
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.cornerRadius = 0
        }
    }
    
    func isSelected(selectedButton button: UIButton) -> Bool {
        return selectedButtons.contains(button)
    }
    
    func deselectNotSetButtons() {
        for button in buttons {
            button.setNewStyle(to: getStyle)
        }
    }
    
    func endGame() {
        let alert = UIAlertController(title: "Game Over", message: "No Further Moves!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.default, handler: {action in self.game.exitGame()}))
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: {action in self.newGame(UIButton())}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func allMatchedCardButtonsAreVisible(threeSetCards: [Int]) -> Bool{
        for cardIndex in 0..<threeSetCards.count {
            let cardIdentifier = threeSetCards[cardIndex]
            for button in buttons {
                if button.tag == cardIdentifier {
                    if button.layer.backgroundColor == #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    
    func showThreeMatchedCards() {
        let threeSetCards = game.getASet()
        if threeSetCards != nil && allMatchedCardButtonsAreVisible(threeSetCards: threeSetCards!) { // button will become unvisible if deck is empty
            for cardIndex in 0..<threeSetCards!.count {
                let cardIdentifier = threeSetCards![cardIndex]
                for button in buttons {
                    if button.tag == cardIdentifier {
                        button.setStyleToHint()
                    }
                }
            }
        }
        else {
            if game.deck.count == 0 {
                endGame()
            }
            let alert = UIAlertController(title: "", message: "No available set on the board", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Deal 3 More Cards", style: UIAlertActionStyle.default, handler: {action in self.dealCardsAndAddToGameBoard(UIButton())}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addButtonsToMatchedButtonsArray() {
        matchedButtons.removeAll()
        for buttonIndex in 0..<selectedButtons.count {
            matchedButtons.append(selectedButtons[buttonIndex])
        }
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(game.score)"
        deckLabel.text = "Cards in Deck: \(game.deck.count)"
    }
    
    func changeCardsShapeToSet() {
        for button in selectedButtons {
            button.setStyleToGoodSetGuess()
        }
    }
    
    func changeCardsShapeToNotASet() {
        for button in selectedButtons {
            button.setStyleToWrongSetGuess()
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
        buttons.disableAllElements()
        
        for cardIndex in 0..<game.numOfCardsOnStart {
            game.cardsOnGameBoard.append(game.deck[cardIndex])
            game.deck.remove(at: cardIndex)
            let card = game.cardsOnGameBoard[cardIndex]
            let shape = shapes[card.shape]
            
            let shade = printShape(ofShape: shapeToShading[shape]![card.shading].string, times: card.numOfShapes + 1)
            let foregroundColor = getColor(forCard: card)
            let attString = NSAttributedString(string: shade, attributes: [NSAttributedStringKey.foregroundColor : foregroundColor])
            buttons.setButton(atIndex: cardIndex, tag: card.identifier, attributedString: attString, for: UIControlState.normal)
        }
    }
    
    func getColor (forCard card: Card) ->  UIColor{
        let color = card.color
        switch color {
        case colorType.red.rawValue:
            return UIColor.red
        case colorType.green.rawValue:
            return UIColor.green
        case colorType.blue.rawValue:
            return UIColor.blue
        default:
            return UIColor.black 
            
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
        button.setNewStyle(to: getStyle)
    }
}

extension UIButton {
    
    func setNewStyle(to res: (UIButton) -> CGColor?) {
        switch res(self) {
        case #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1):
            self.layer.borderWidth = 3.0
            self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.layer.cornerRadius = 8.0
        case #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1):
            self.layer.borderWidth = 3.0
            self.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            self.layer.cornerRadius = 8.0
        case #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1):
            self.layer.borderWidth = 3.0
            self.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            self.layer.cornerRadius = 8.0
        default:
            self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    
    func setStyleToFreeSpace() {
        self.layer.borderWidth = 0
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = 0
    }
    
    func setStyleToClicked() {
        self.layer.borderWidth = 3.0
        self.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        self.layer.cornerRadius = 8.0
    }
    
    func setStyleToHint() {
        self.layer.borderWidth = 3.0
        self.layer.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        self.layer.cornerRadius = 8.0
    }
    
    func setStyleToGoodSetGuess() {
        self.layer.borderWidth = 5.0
        self.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        self.layer.cornerRadius = 8.0
    }
    
    func setStyleToWrongSetGuess() {
        self.layer.borderWidth = 3.0
        self.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        self.layer.cornerRadius = 8.0
    }
}

extension Array where Element:UIButton {
    func disableAllElements() {
        for element in self {
            element.isEnabled = false
        }
    }
    
    func setButton(atIndex cardIndex: Int, tag buttonTag: Int, attributedString attribute: NSAttributedString, for controlState: UIControlState) {
        self[cardIndex].setAttributedTitle(attribute, for: controlState)
        self[cardIndex].tag = buttonTag
        self[cardIndex].isEnabled = true
    }
}

