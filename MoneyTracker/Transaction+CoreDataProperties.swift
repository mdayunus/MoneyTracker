//
//  Transaction+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 14/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var cashOrCheque: [String]
    @NSManaged public var id: String
    @NSManaged public var madeAt: Date
    @NSManaged public var creditOrDebit: Bool
    @NSManaged public var byMember: Member
    @NSManaged public var credit: Credit
    @NSManaged public var debit: Debit
    @NSManaged public var onDay: Day

}
