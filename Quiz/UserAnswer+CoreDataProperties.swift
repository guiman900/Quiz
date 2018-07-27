//
//  UserAnswer+CoreDataProperties.swift
//  Quiz
//
//  Created by Guillaume Manzano on 24/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreData


extension UserAnswer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAnswer> {
        return NSFetchRequest<UserAnswer>(entityName: "UserAnswer")
    }

    @NSManaged public var status: String?
    @NSManaged public var bonus: String?
    @NSManaged public var time: Int
    @NSManaged public var userReponseId: String?
    @NSManaged public var question: Question?
}
