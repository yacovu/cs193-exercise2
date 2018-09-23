//
//  ViewController.swift
//  Set
//
//  Created by Yacov Uziel on 20/09/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let game = Set()
//    private let shapes = [NSAttributedString(string: "\u{25A1}", attributes: [NSAttributedStringKey.foregroundColor : UIColor.green])]
    private let colors = ["red", "green", "blue"]
    private let shading = ["d"]
    private let numberOfShapes = [1,2,3]
    lazy private var shapes = [diamond,square,circle]
    
    private let diamond = NSAttributedString(string: "\u{25CA}")
    private let square = NSAttributedString(string: "\u{25A2}")
    private let circle = NSAttributedString(string: "\u{25EF}")

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
        if let touchedCardIndex = buttons.index(of: sender) {
            game.selectCard(atIndex: touchedCardIndex)
            changeShape(ofButton: sender)
            updateUI()
        }
        
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(game.score)"
        
        

    }
    
//    [NSAttributedString(string: "\u{25A1}", attributes: [NSAttributedStringKey.foregroundColor : UIColor.green])]
    
    func initGameBoard() {
        for cardIndex in 0..<game.numOfCardsOnStart {
            let cardProperty = getProperties(forCard: game.deck[cardIndex])
            let shape = printShape(ofShape: shapes[cardProperty[1]].string, times: numberOfShapes[cardProperty[3]])
            let foregroundColor = getColor(fromCardProperty: cardProperty)
            buttons[cardIndex].setAttributedTitle(NSAttributedString(string: shape, attributes: [NSAttributedStringKey.foregroundColor : foregroundColor]), for: UIControlState.normal)
        }
    }
    
    func getColor (fromCardProperty cardProperty: [Int]) ->  UIColor{
        let color = colors[cardProperty[0]]
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
        }
        else {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            button.layer.cornerRadius = 8.0
        }
//        button.setAttributedTitle(shapes[0], for: UIControlState.normal)
    }
    
    var cardProperties = [Int:[Int]]()
    
    //returns color, shape, shading and number of shapes for a specific card
    func getProperties(forCard card: Card) -> [Int] {
        if cardProperties[card.identifier] == nil {
            let randomColor = Int(arc4random_uniform(UInt32(colors.count)))
            let randomShape = Int(arc4random_uniform(UInt32(shapes.count)))
            let randomShading = Int(arc4random_uniform(UInt32(shading.count)))
            let randomNumOfShapes = Int(arc4random_uniform(UInt32(numberOfShapes.count)))
            cardProperties[card.identifier] = [randomColor, randomShape, randomShading, randomNumOfShapes]
        }
        return cardProperties[card.identifier] ?? [-1, -1, -1, -1]
    }



}

