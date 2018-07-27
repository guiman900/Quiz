//
//  GameManager.swift
//  Quiz
//
//  Created by Guillaume Manzano on 24/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/**
Game Manager implement the logic of a game.
 */
class GameManager {
    // - MARK: Properties
    /// shared instance of the game manager
    static let gameManager = GameManager()
    /// Core data context
    var managedObjectContext: NSManagedObjectContext? = nil
    /// GameProtocol delegate used to communicate with the GameController
    var delegate: GameProtocol?
    
    /// questions loaded for the game
    private var questions: [Question] = []
    /// current index of the question
    private var index: Int = 0
    /// available bonus for the rest of the game
    private var availableBonus: BonusEnum = .all
    /// is the game started
    private var gameStarted = false
    /// worst time to answser a question during the game
    private var worstTime = 0
    /// best time to answser a question during the question
    private var bestTime = 0
    
    // - MARK: Methods
    /**
     Init the game (load from network / json file and from core data in case of the network doesn't work for the second game).
     Return the first question
     */
    internal func initGame(completion: (_ question: Question?) -> Void)
    {
        self.questions = []
        if self.managedObjectContext == nil {
            self.managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        }
        
        self.getQuestionsStored()
        
        NetworkManager.networkManager.getQuestions(url: "") {
            (result: [[String: Any]]) in
            self.loadJsonFile(quiz: result)
            self.selectTenQuestions()
            
            self.gameStarted = true
            self.availableBonus = .all
            self.index = 0
            self.worstTime = -1
            self.bestTime = 26
            completion(questions[0])
        }
    }
    
    /**
     Get 10 random questions from the question array
    */
    private func selectTenQuestions()
    {
        var selectedQuestions: [Question] = []
        while (selectedQuestions.count < 10) {
            let index = Int(arc4random_uniform(UInt32(self.questions.count)))
            if selectedQuestions.contains(self.questions[index]) == false
            {
                selectedQuestions.append(self.questions[index])
            }
        }
        self.questions = selectedQuestions
    }
    
    
    /**
     Load the questions saved in core data
    */
    private func getQuestionsStored()
    {
        if self.managedObjectContext == nil {
            self.managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.managedObjectContext?.fetch(request)
            if result != nil
            {
                for data in result as! [NSManagedObject] {
                    if let question = data as? Question {
                        self.questions.append(question)
                    }
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    /**
     Get the game results saved in core data
    */
    private func getGameResultStored() -> [GameResult]
    {
        
        if self.managedObjectContext == nil {
            self.managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        }
        

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GameResult")
        var gameResults: [GameResult] = []
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.managedObjectContext?.fetch(request)
            if result != nil
            {
                for data in result as! [NSManagedObject] {
                    if let gameResult = data as? GameResult {
                       gameResults.append(gameResult)
                    }
                }
            }
        } catch {
            print("Failed")
        }
        return gameResults
    }

    /**
     is the first game result better than the second game result.
     Based on the number of rightAnswser and the time took by the user.
     
     - Parameter this: the first game result to compare
     - Parameter that: the second game result to compare
    */
    private func isBigger(this: GameResult, that: GameResult) -> Bool {
        if this.rightAnswers == that.rightAnswers {
            return this.totalTime < that.totalTime
        }
        return this.rightAnswers > that.rightAnswers
    }
    
    /**
     Return an ordered array of game result from core data
    */
    internal func getGameResultOrdered() -> [GameResult]
    {
        let gameResults = self.getGameResultStored()
        return gameResults.sorted(by: isBigger)
    }
    
    /**
     Load the questions from a json file.
     
     - Parameter quiz: Array get from the network
    */
    private func loadJsonFile(quiz: [[String: Any]])
        {
                        for jsonItem in quiz {
                            if let context = self.managedObjectContext {
                                if let question = Question.createQuestion(data: jsonItem, context: context) {
                                  self.checkQuestionExist(question: question, context: context)
                                }
                            }
                        }
        }

    
    /**
     Check if the questions exist in core data.
     Erase the old version of the question in case of a changed has been made.
     Could add a last updated date into the json to don't update everytime.
    */
    private func checkQuestionExist(question: Question, context: NSManagedObjectContext)
    {
        if let index = self.questions.index(where: {$0.id == question.id})
        {
            let oldQuestion = self.questions[index]
            self.questions.remove(at: index)
            self.questions.append(question)
            
            do {
                context.delete(oldQuestion)
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        else {
            self.questions.append(question)
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }

        }
    }
    
    /**
     Return the next question to display
    */
    internal func getNextQuestion() -> Question?
    {
        if index >= 9 {
            self.gameStarted = false
            return nil
        }
        
        self.index += 1
        return self.questions[index]
    }
    
    /**
     Get the current question
    */
    internal func getCurrentQuestion() -> Question?
    {
        return self.questions[index]
    }
    
    /**
     Set the user response
     
     - Parameter status: if the user doesn't answer to the question.
     - Parameter responseId; the id of the user response.
     - Parameter time: time remaining before the question finished
    */
    internal func setResponse(status: AnswerStatusEnum, responseId: String, time: Int) -> AnswerStatusEnum
    {
        if let bonusText = self.questions[index].userAnswer?.bonus, let bonusUsed = BonusEnum(rawValue: bonusText) {
            let totaltime =  15 + (bonusUsed == .all || bonusUsed == .extraTime ? 10 : 0) - time
            
            self.bestTime = totaltime < self.bestTime ? totaltime : self.bestTime
            self.worstTime = totaltime > self.worstTime ? totaltime : self.worstTime

            self.questions[index].userAnswer?.time = totaltime
            self.questions[index].userAnswer?.userReponseId = responseId
            
            if (status == .unanswered) {
                self.questions[index].userAnswer?.status = status.rawValue
                return status
            }

            if let value = self.questions[index].answers?.first(where: {($0 as? Answer)?.id == responseId}) as? Answer {
                let finalStatus = value.isRight == true ? AnswerStatusEnum.correct : AnswerStatusEnum.wrong
                self.questions[index].userAnswer?.status = finalStatus.rawValue
                return finalStatus
            }
        }
        return .undefined
    }
    
    /**
     Get all the question of the current game
    */
    internal func getQuestions() -> [Question]
    {
        return self.questions
    }
    
    /**
     Indicate that the user used a bonus
     
    - Parameter bonus: the bonus used.
    */
    internal func useBonus(bonus: BonusEnum)
    {
        if let answer = questions[self.index].userAnswer, let responseBonus = answer.bonus {
            if BonusEnum(rawValue: responseBonus) == BonusEnum.none {
                answer.bonus = bonus.rawValue
            }
            else {
                answer.bonus = BonusEnum.all.rawValue
            }
            self.setAvailableBonus(bonusUsed: bonus)
        }
    }
    
    /**
     Set the remaining bonus available for the game
     
    - Parameter bonusUsed: the bonus that has been used.
    */
    private func setAvailableBonus(bonusUsed: BonusEnum)
    {
        if self.availableBonus == .all {
            self.availableBonus = bonusUsed == .extraTime ? .fiftyFifty : .extraTime
        }
        else {
            self.availableBonus = .none
        }
    }
    
    /**
     Get the remaining bonus for the game
    */
    internal func getAvailableBonus() -> BonusEnum {
        return self.availableBonus
    }
    
    /**
     Is the game already started
    */
    internal func isGameStarted() -> Bool {
        return self.gameStarted
    }
    
    /**
     Request the next question (used nextQuestion delegate method -> GameViewController)
    */
    internal func requestNextQuestion(){
        self.delegate?.nextQuestion()
    }
    
    /**
     Get the number of questions with the answser status
     
     - Parameter status: the status to filter on
    */
    internal func getQuestionsWithStatus(status: AnswerStatusEnum) -> Int
    {
        return self.questions.filter({$0.userAnswer?.getStatus() == status}).count
    }
    
    /**
     Get the best or the worst time based on the parameter
     
     - Parameter bestTime: true to get the best time, false to get the worst time
    */
    internal func getQuestionTimeDetails(bestTime: Bool) -> Int
    {
        return bestTime == true ? self.bestTime : self.worstTime
    }
    
    /**
     Get how many seconds the user took to finish the game
    */
    internal func getTotalTime() -> Int {
        var totalTime = 0
        for question in self.questions {
            if let time = question.userAnswer?.time {
                totalTime += time
            }
        }
        return totalTime
    }
}
