//
//  GameResult+CoreDataClass.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreData

/**
GameResult Core Data Model implementation
 */
public class GameResult: NSManagedObject {
    // - MARK: Methods
    /**
     static method to create a GameResult using the GameManager
     */
    internal class func createGameResultWithGameManagerData() -> GameResult?
    {
        if let context = GameManager.gameManager.managedObjectContext, let gameResult =  NSEntityDescription.insertNewObject(forEntityName: "GameResult", into: context) as? GameResult {
            gameResult.rightAnswers = GameManager.gameManager.getQuestionsWithStatus(status: AnswerStatusEnum.correct)
            gameResult.wrongAnswers = GameManager.gameManager.getQuestionsWithStatus(status: AnswerStatusEnum.wrong)
            gameResult.unanswered = GameManager.gameManager.getQuestionsWithStatus(status: AnswerStatusEnum.unanswered)
            gameResult.totalTime = GameManager.gameManager.getTotalTime()
            return gameResult
        }
        return nil
    }
    
    // - MARK: Methods
    /**
     Static method to save the GameResult created on the context
     */
    internal class func saveGameResult()
    {
        if let context = GameManager.gameManager.managedObjectContext
        {
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
}
