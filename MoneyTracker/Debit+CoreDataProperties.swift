//
//  Debit+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 29/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Debit {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Debit> {
        return NSFetchRequest<Debit>(entityName: "Debit")
    }

    @NSManaged public var amount: Double
    @NSManaged public var purpose: String
    @NSManaged public var invDebit: Transaction

}
