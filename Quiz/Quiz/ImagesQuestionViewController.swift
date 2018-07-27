//
//  ImagesQuestionViewController.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
 Image Question View Controller is used to display the question of type Images
 */
class ImagesQuestionViewController: UIViewController {
    // - MARK: Properties
    /// question label
    @IBOutlet weak var question: UILabel!
    /// first answser button
    @IBOutlet weak var firstResponse: UIButton!
    /// second answser button
    @IBOutlet weak var secondResponse: UIButton!
    /// third answser button
    @IBOutlet weak var thirdResponse: UIButton!
    /// fourth answser button
    @IBOutlet weak var fourthResponse: UIButton!
    
    /// image of the first button
    @IBOutlet weak var firstImage: UIImageView!
    /// image of the second button
    @IBOutlet weak var secondImage: UIImageView!
    /// image of the third button
    @IBOutlet weak var thirdImage: UIImageView!
    /// image of the fourth button
    @IBOutlet weak var fourthImage: UIImageView!
    /// background image
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    /// fifty fifty bonus button
    @IBOutlet weak var fiftyFifty: UIButton!
    /// extra time bonus button
    @IBOutlet weak var extraTime: UIButton!
    
    /// time remaining label
    @IBOutlet weak var timerLabel: UILabel!
    
    /// current question to display
    private var currentQuestion: Question?
    
    // - MARK: Methods
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        TimerManager.timerManager.delegate = self
        TimerManager.timerManager.runTimer()
        self.backgroundImageView.layer.zPosition = -1
    }
    
    /**
     Called after the view controller's view received a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Init the labels and the buttons text
     */
    private func initView()
    {
        self.currentQuestion = GameManager.gameManager.getCurrentQuestion()
        self.question.text = self.currentQuestion?.text
        
        
        self.firstImage.image = UIImage.load(fileName: ((self.currentQuestion?.answers?.allObjects[0] as? Answer))?.content)
        self.secondImage.image = UIImage.load(fileName: ((self.currentQuestion?.answers?.allObjects[1] as? Answer))?.content)
        self.thirdImage.image = UIImage.load(fileName: ((self.currentQuestion?.answers?.allObjects[2] as? Answer))?.content)
        self.fourthImage.image = UIImage.load(fileName: ((self.currentQuestion?.answers?.allObjects[3] as? Answer))?.content)
      
        self.setBonusButtons()
    }
    
    /**
     set the available bonus buttons
     */
    private func setBonusButtons()
    {
        let availableBonus = GameManager.gameManager.getAvailableBonus()
        self.fiftyFifty.isHidden = availableBonus == .all || availableBonus == .fiftyFifty ? false : true
        self.extraTime.isHidden = availableBonus == .all || availableBonus == .extraTime ? false : true
    }
    
    /**
     Method called when the user clicked on an answser
     
     - Parameter sender: the button clicked
     */
    @IBAction func buttonPressed(_ sender: Any) {
        if let tag = (sender as? UIButton)?.tag, let responseId = (self.currentQuestion?.answers?.allObjects[tag] as? Answer)?.id {
            TimerManager.timerManager.stopTimer()
            let result = GameManager.gameManager.setResponse(status: .undefined, responseId: responseId, time: TimerManager.timerManager.getSeconds())
           
            self.createImageView(status: result, tag: tag)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                GameManager.gameManager.requestNextQuestion()
            })
        }
    }
    
    private func createImageView(status: AnswerStatusEnum, tag: Int)
    {
        let imageName = status == . correct ? "check-mark" : "wrong"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        switch tag {
        case 0:
            imageView.frame = firstImage.frame
        case 1:
            imageView.frame = secondImage.frame
        case 2:
            imageView.frame = thirdImage.frame
        case 3:
            imageView.frame = fourthImage.frame
        default:
            break
        }
        
        view.addSubview(imageView)
    }
    
    /*
     Method called when the user clicked on the bonus Fifty Fifty
     
     - Parameter sender: the button clicked
     */
    @IBAction func bonusFiftyFifty(_ sender: Any) {
        GameManager.gameManager.useBonus(bonus: BonusEnum.fiftyFifty)
        self.setBonusButtons()
        
        var indexSelected: [Int] = []
        while (indexSelected.count < 2) {
            let number = Int(arc4random_uniform(4))
            if ((self.currentQuestion?.answers?.allObjects[number] as? Answer))?.isRight == false && indexSelected.contains(number) == false
            {
                switch number {
                case 0:
                    self.firstResponse.isHidden = true
                    self.firstImage.isHidden = true
                case 1:
                    self.secondResponse.isHidden = true
                    self.secondImage.isHidden = true
                case 2:
                    self.thirdResponse.isHidden = true
                    self.thirdImage.isHidden = true
                case 3:
                    self.fourthResponse.isHidden = true
                    self.fourthImage.isHidden = true
                default:
                    break
                }
                indexSelected.append(number)
            }
        }
    }
    
    /*
     Method called when the user clicked on the bonus extra time
     
     - Parameter sender: the button clicked
     */
    @IBAction func bonusExtraTime(_ sender: Any) {
        GameManager.gameManager.useBonus(bonus: BonusEnum.extraTime)
        TimerManager.timerManager.useTimeBonus()
        self.setBonusButtons()
    }
}

extension ImagesQuestionViewController: TimerProtocol {
    /**
     timer has been updated with a new time
     
     - Parameter timeLeft: time remaining before the end of the timer
     */
    func updateTimer(timeLeft: Int)
    {
        self.timerLabel.text = "\(timeLeft)"
        if timeLeft <= 0 {
            _ = GameManager.gameManager.setResponse(status: .unanswered, responseId: "", time: 0)
            GameManager.gameManager.requestNextQuestion()
        }
    }
}

