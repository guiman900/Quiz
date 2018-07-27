//
//  Question+CoreDataProperties.swift
//  Quiz
//
//  Created by Guillaume Manzano on 24/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var id: String?
    @NSManaged public var type: String?
    @NSManaged public var text: String?
    @NSManaged public var image: String?
    @NSManaged public var userAnswer: UserAnswer?
    @NSManaged public var answers: NSSet?

}

// MARK: Generated accessors for answers
extension Question {

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: Answer)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: Answer)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSSet)

}
