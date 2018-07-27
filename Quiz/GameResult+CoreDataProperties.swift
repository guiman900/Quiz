//
//  GameResult+CoreDataProperties.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreData


extension GameResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameResult> {
        return NSFetchRequest<GameResult>(entityName: "GameResult")
    }

    @NSManaged public var rightAnswers: Int
    @NSManaged public var wrongAnswers: Int
    @NSManaged public var unanswered: Int
    @NSManaged public var totalTime: Int

}
