//
//  iphoneMode.swift
//  SetGame
//
//  Created by Yacov Uziel on 02/10/2018.
//  Copyright © 2018 Yacov Uziel. All rights reserved.
//

import Foundation

protocol IphonePlayerMode {
    
    func selectGameMode() -> SetGame.gameMode
    
    func startSinglePlayerMode()
    
    func startAgainstIphoneMode()
    
//    func startThinking(forHowLong timeInterval: Int, clousre)
    
    func stopThinking()
    
    func makeATurn()
}
