//
//  Day+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 14/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var day: Date
    @NSManaged public var transactions: NSArray
    @NSManaged public var inGroup: Group

}

// MARK: Generated accessors for transactions
extension Day {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
