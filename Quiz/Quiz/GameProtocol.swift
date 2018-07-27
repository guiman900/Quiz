//
//  GameProtocol.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
Protocol used by the SubGameViewController/FinishedGameViewController to communicate with the GameViewController
 */
protocol GameProtocol {
    // - MARK: Methods
    /**
     Get the next question and init the next ViewController
     */
    func nextQuestion()
    
    /**
     Message send by the FinishedGameViewController to go back to the menu
     */
    func returnToRootViewController()
}
