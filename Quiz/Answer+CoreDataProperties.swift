//
//  Answer+CoreDataProperties.swift
//  Quiz
//
//  Created by Guillaume Manzano on 24/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreData


extension Answer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answer> {
        return NSFetchRequest<Answer>(entityName: "Answer")
    }

    @NSManaged public var id: String?
    @NSManaged public var content: String?
    @NSManaged public var isRight: Bool
    @NSManaged public var question: Question?
}
