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
    private let deck = [Card]()
//    private let shapes = [NSAttributedString(string: "\u{25A1}", attributes: [NSAttributedStringKey.foregroundColor : UIColor.green])]
    private let colors = ["red", "green", "blue"]
    private let filling = ["d"]
    private let numberOfShapes = [1,2,3]
    
    
       lazy private var shapes = [square]
    
    private let square = NSAttributedString(string: "\u{25A1}")

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
    
    func changeShape(ofButton button: UIButton) {
        button.layer.borderWidth = 3.0
        button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        button.layer.cornerRadius = 8.0
        button.setAttributedTitle(shapes[0], for: UIControlState.normal)
    }
    
   
                    
//                    for buttonIndex in buttons.indices{
//                        buttons[buttonIndex].setAttributedTitle(shapes[0], for: UIControlState.normal)
//                    }
    
    var colorShapeFiiling = [Int:[Int]]()
    
    func getColorShapeFilling(for card: Card) -> [Int] {
        if colorShapeFiiling[card.identifier] == nil {
            let randomColor = Int(arc4random_uniform(UInt32(colors.count)))
            let randomShape = Int(arc4random_uniform(UInt32(shapes.count)))
            let randomFilling = Int(arc4random_uniform(UInt32(filling.count)))
            let randomNumOfShapes = Int(arc4random_uniform(UInt32(numberOfShapes.count)))
            colorShapeFiiling[card.identifier] = [randomColor, randomShape, randomFilling, randomNumOfShapes]
        }
        return colorShapeFiiling[card.identifier] ?? [-1, -1, -1, -1]
    }



}

