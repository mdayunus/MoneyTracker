//
//  Member+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 01/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: String
    @NSManaged public var imageData: Data
    @NSManaged public var name: String
    @NSManaged public var lastEditedAt: Date
    @NSManaged public var emailID: String
    @NSManaged public var inGroup: NSSet
    @NSManaged public var transactions: NSSet

}

// MARK: Generated accessors for inGroup
extension Member {

    @objc(addInGroupObject:)
    @NSManaged public func addToInGroup(_ value: Group)

    @objc(removeInGroupObject:)
    @NSManaged public func removeFromInGroup(_ value: Group)

    @objc(addInGroup:)
    @NSManaged public func addToInGroup(_ values: NSSet)

    @objc(removeInGroup:)
    @NSManaged public func removeFromInGroup(_ values: NSSet)

}

// MARK: Generated accessors for transactions
extension Member {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
