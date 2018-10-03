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
        selectGameMode()
//        sleep(10)
//        dealCardsAndAddToGameBoard()
        
    }
    
    func selectGameMode() {
        
        let alert = UIAlertController(title: "Game Mode", message: "Please Select Game Mode" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Single Player", style: UIAlertActionStyle.default, handler: {action in self.setGameMode(gameMode: SetGame.gameMode.singlePlayer)}))
        alert.addAction(UIAlertAction(title: "Play Againts Computer", style: UIAlertActionStyle.default, handler: {action in self.setGameMode(gameMode: SetGame.gameMode.playAgainstComputer)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setGameMode(gameMode mode: SetGame.gameMode) {
        switch mode {
        case SetGame.gameMode.playAgainstComputer:
            computerStatusIndicator.text = "🤔"
            computerScore.text = "Computer's Score: 0"
            let timeToThink = Int(arc4random_uniform(60))
            startGameAgainstComputer(forHowLong: timeToThink)
            
            
        default:
            computerStatusIndicator.text = ""
            computerScore.text = ""
        }
        
    }
    
    func startGameAgainstComputer(forHowLong timeInterval: Int) {
//        while game.deck.count > 0 {
            startThinking(forHowLong: timeInterval)
//            print(game.deck.count)
//        }        
    }
    
    
    func startThinking(forHowLong timeInterval: Int) {
//        var timeToThink = Int(arc4random_uniform(60))
        var timeToThink = 2
        var setCards: [Int]?
        
        self.changeEmojiIndicatorToThinking()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timeToThink -= 1
            print("timeToThink1: \(timeToThink)")
            if timeToThink == 0 {
                setCards = self.game.getASet()
                if setCards != nil {
                    self.changeEmojiIndicatorToHappy()
                    self.waitAndMakeMove(withSetCards: setCards!)
                }
                else {
                    self.changeEmojiIndicatorToUnhappy()
                    self.dealCardsAndAddToGameBoard()
                }
                timer.invalidate()
            }
        }
    }
    
    func waitAndMakeMove(withSetCards setCards: [Int]){
        var timeToThink = 2 // wait 2 seconds before make a move
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print ("time to think2: \(timeToThink)")
            timeToThink -= 1
            if timeToThink == 0 {
                self.disableAllGameBoardButtons()
                self.resetSelectedButtons()
                self.showComputerSet(setCards: setCards)
                self.addButtonsToMatchedButtonsArray()
                self.game.scoreComputer += 3
                self.enableAllGameBoardButtons()
                self.dealCardsAndAddToGameBoard()
                timer.invalidate()
            }
        }
    }
    
    func disableAllGameBoardButtons() {
        for buttonIndex in 0..<freeButtonIndex {
            buttons[buttonIndex].isEnabled = false
        }
    }
    
    func enableAllGameBoardButtons() {
        for buttonIndex in 0..<freeButtonIndex {
            buttons[buttonIndex].isEnabled = true
        }
    }
    
    func resetSelectedButtons() {
        selectedButtons.removeAll()
    }
    
    func showComputerSet(setCards threeSetCards: [Int]) {
        for cardIndex in 0..<threeSetCards.count {
            let cardIdentifier = threeSetCards[cardIndex]
            for button in buttons {
                if button.tag == cardIdentifier {
                    selectedButtons.append(button)
                    button.setStyleToGoodSetGuess()
                }
            }
        }
//            needToDealNewCards = true
//            self.game.scoreComputer += 3
//            if game.deck.count == 0 {
//                hideMatchSetFromUI()
//                removeMatchSetFromGameBoard()
//            }
//            if game.cardsOnGameBoard.count == 0 {
//                winGame()
//            }
//
//                selectedButtons.removeAll()
//            }
//            updateUI()
    }

    
    func changeEmojiIndicatorToWin() {
        
    }
    
    func changeEmojiIndicatorToThinking() {
        computerStatusIndicator.text = "🤔"
    }
    
    func changeEmojiIndicatorToHappy() {
        computerStatusIndicator.text = "😁"
    }
    
    func changeEmojiIndicatorToUnhappy() {
        computerStatusIndicator.text = "😤"
    }
    
    func reset(scheduledTimer timer: Timer){

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
        game.scorePlayer -= 1
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
    
    @IBOutlet weak var computerScore: UILabel!
    
    @IBOutlet weak var computerStatusIndicator: UILabel!
    
    @IBOutlet weak var dealCard: UIButton!
    
    @IBAction func dealCardsAndAddToGameBoard(_ sender: UIButton) {
        checkIfNeedToEnd()
        dealCardsAndAddToGameBoard()

        if game.cardsOnGameBoard.count == game.maxGameBoardCapacity { // insufficient cards in the game board. The button is disabled
            sender.isEnabled = false
        }
        needToDealNewCards = false
        matchedButtons.removeAll()
        updateUI()
    }
    
    func dealCardsAndAddToGameBoard() {
        let threeNewCards = game.dealThreeNewCards() // get three new cards from the deck
        if threeNewCards.count == 3 {
            if matchedButtons.count == 3 {
                replaceThreeMatchedCardsWithNewOnes(newCards: threeNewCards)
            }
            else if game.cardsOnGameBoard.count <= game.maxGameBoardCapacity - 3 {
                addThreeNewCardsToNewPlaces(newCards: threeNewCards)
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
    }
    
    func replaceThreeMatchedCardsWithNewOnes(newCards threeNewCards: [Card]) {
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
    
    func addThreeNewCardsToNewPlaces(newCards threeNewCards: [Card]) {
        for index in 0..<3 {
            let shade = printShape(ofShape: shapeToShading[shapes[threeNewCards[index].shape]]![threeNewCards[index].shading].string, times: threeNewCards[index].numOfShapes + 1)
            let attString = NSAttributedString(string: shade, attributes: [NSAttributedStringKey.foregroundColor : getColor(forCard: threeNewCards[index])])
            buttons.setButton(atIndex: freeButtonIndex, tag: threeNewCards[index].identifier, attributedString: attString, for: UIControlState.normal)
            freeButtonIndex += 1
        }
        addThreeNewCardsToGameBoard(threeCards: threeNewCards)
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
    
    
    @IBOutlet weak var playerScoreLabel: UILabel!
    
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
                clearButttons()
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
                    game.scorePlayer += 3
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
                    
                    game.scorePlayer -= 5
                }
                selectedButtons.removeAll()
            }
            updateUI()
        }
    }
    
    func deselectCard(atTouchedCardIndex touchedCardIndex: Int, button cardButton: UIButton) {
        var deleted = false
        game.deselectCard(atIndex: touchedCardIndex)
        for buttonIndex in 0..<selectedButtons.count where !deleted {
            if selectedButtons[buttonIndex] == cardButton {
                selectedButtons.remove(at: buttonIndex)
                deleted = true
            }
        }
    }
    
    func selectCard(atTouchedCardIndex touchedCardIndex: Int, button cardButton: UIButton) {
        game.selectCard(atIndex: buttons[touchedCardIndex].tag)
        selectedButtons.append(cardButton)
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
        playerScoreLabel.text = "Player's Score: \(game.scorePlayer)"
        computerScore.text = "Computer's Score: \(game.scoreComputer)"
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
        button.setNewStyle(style: getStyle)
    }
}

extension UIButton {
    
    func setNewStyle(style buttonStyle: (UIButton) -> CGColor?) {
        switch buttonStyle(self) {
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

