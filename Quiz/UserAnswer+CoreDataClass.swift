//
//  UserAnswer+CoreDataClass.swift
//  Quiz
//
//  Created by Guillaume Manzano on 24/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreData

/**
 UserAnswer Core Data Model implementation
 */
public class UserAnswer: NSManagedObject {
    // - MARK: Methods
    /**
     static method to create an UserAnswer using the GameManager
     
     - Parameter context: core data context
     */
    internal class func createUserAnswer(context: NSManagedObjectContext) -> UserAnswer?
    {
        let userAnswer =  NSEntityDescription.insertNewObject(forEntityName: "UserAnswer", into: context) as? UserAnswer
        userAnswer?.status = AnswerStatusEnum.undefined.rawValue
        userAnswer?.bonus = BonusEnum.none.rawValue
        userAnswer?.time = 0
        userAnswer?.userReponseId = nil
        return userAnswer
    }
    
    /**
     get the userAnswer status as an AnswerStatusEnum
     */
    internal func getStatus() -> AnswerStatusEnum
    {
        if let status = self.status, let answerStatus = AnswerStatusEnum(rawValue: status)
        {
            return answerStatus
        }
        return AnswerStatusEnum.undefined
    }
    
    /**
     get the userAnswer bonus as a BonusEnum
     */
    internal func getBonus() -> BonusEnum
    {
        if let bonus = self.bonus, let answerBonus = BonusEnum(rawValue: bonus)
        {
            return answerBonus
        }
        return BonusEnum.none
    }
    
    /**
     get the response text for an id question
     
     - Parameter id: question id
     */
    internal func getReponseTextForId(id: String?, isId : Bool = true) -> String? {
        if let id = id, let response = self.question?.answers?.allObjects.first(where: {($0 as? Answer)?.id == id}) as? Answer
        {
            return response.content
        }
        return nil
    }
    
}
