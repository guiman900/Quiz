//
//  GameViewController.swift
//  Quiz
//
//  Created by Guillaume Manzano on 24/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import UIKit

/**
 Game View Controller, used to load the TextQuestionViewController and the ImagesQuestionViewController
 */
class GameViewController: UIViewController {
    // - MARK: Properties
    /// current question to display
    fileprivate var currentQuestion: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // - MARK: Methods
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewWillAppear(_ animated: Bool) {
        if GameManager.gameManager.isGameStarted() == false {
            GameManager.gameManager.delegate = self
            GameManager.gameManager.initGame() {
                (question: Question?) in
                self.currentQuestion = question
                self.selectNextViewController()
                
            }
        }
    }
    
    /**
     Called after the view controller's view received a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Select the view controller to load based on the question type
    */
    fileprivate func selectNextViewController(){
        if currentQuestion == nil {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FinishedGameViewController") as? FinishedGameViewController {
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
        else if currentQuestion?.getQuestionType() == .text {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TextQuestionViewController") as? TextQuestionViewController {
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
        else if currentQuestion?.getQuestionType() == .images {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ImagesQuestionViewController") as? ImagesQuestionViewController {
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
    }
}

extension GameViewController: GameProtocol {
    /**
     Get the next question and init the next ViewController
     */
    func nextQuestion()
    {
        self.currentQuestion = GameManager.gameManager.getNextQuestion()
        self.selectNextViewController()
    }
    
    /**
     Message send by the FinishedGameViewController to go back to the menu
     */
    func returnToRootViewController()
    {
        self.navigationController?.popToRootViewController(animated: false)
    }
}
