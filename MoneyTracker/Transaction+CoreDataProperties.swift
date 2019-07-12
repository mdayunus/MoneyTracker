//
//  Transaction+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 03/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var cashOrCheque: [String]
    @NSManaged public var creditOrDebit: String
    @NSManaged public var id: String
    @NSManaged public var madeAt: Date
    @NSManaged public var noteOrPurpose: String
    @NSManaged public var byMember: MemberInfo
    @NSManaged public var inGroup: Group

}
