//
//  Question+CoreDataClass.swift
//  Quiz
//
//  Created by Guillaume Manzano on 24/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreData

/**
 Question Core Data Model implementation
 */
public class Question: NSManagedObject {
    // - MARK: Methods
    /**
     static method to create a Question using the json data
     
     - Parameter data: json data get from the local file / network
     - Parameter context: core data context
     */
    internal class func createQuestion(data: [String: Any], context: NSManagedObjectContext) -> Question?
    {
        let question = NSEntityDescription.insertNewObject(forEntityName: "Question", into: context) as? Question
        question?.id = data["id"] as? String
        question?.type = data["type"] as? String
        question?.text = data["text"] as? String
        question?.image = data["image"] as? String
        
        if let result = data["answers"] as? [[String: Any]]
        {
            for jsonAnswer in result {
                if let answer = Answer.createAnswer(data: jsonAnswer, context: context, type: question?.getQuestionType()) {
                    question?.addToAnswers(answer)
                }
            }
        }
        
        question?.userAnswer = UserAnswer.createUserAnswer(context: context)
        return question
    }
    
    /**
     Get the type of the question as a QuestionTypeEnum
    */
    internal func getQuestionType() -> QuestionTypeEnum
    {
        if let type = self.type, let result = QuestionTypeEnum(rawValue: type) {
            return result
        }
        return QuestionTypeEnum.text
    }
    
    /**
     Get the right answser of the question
     */
    internal func getRightAnswer() -> String? {
        if let response = self.answers?.allObjects.first(where: {($0 as? Answer)?.isRight == true}) as? Answer
        {
            return response.content
        }
        return nil
    }
 }
