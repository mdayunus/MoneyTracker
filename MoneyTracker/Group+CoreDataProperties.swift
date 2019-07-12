//
//  Group+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 03/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: String
    @NSManaged public var lastEditedAt: Date
    @NSManaged public var name: String
    @NSManaged public var membersInfo: NSSet
    @NSManaged public var transactions: NSSet

}

// MARK: Generated accessors for membersInfo
extension Group {

    @objc(addMembersInfoObject:)
    @NSManaged public func addToMembersInfo(_ value: MemberInfo)

    @objc(removeMembersInfoObject:)
    @NSManaged public func removeFromMembersInfo(_ value: MemberInfo)

    @objc(addMembersInfo:)
    @NSManaged public func addToMembersInfo(_ values: NSSet)

    @objc(removeMembersInfo:)
    @NSManaged public func removeFromMembersInfo(_ values: NSSet)

}

// MARK: Generated accessors for transactions
extension Group {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
