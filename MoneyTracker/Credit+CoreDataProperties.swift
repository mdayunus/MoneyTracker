//
//  Credit+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 16/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Credit {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Credit> {
        return NSFetchRequest<Credit>(entityName: "Credit")
    }

    @NSManaged public var amount: Double
    @NSManaged public var note: String
    @NSManaged public var invCredit: Transaction

}
