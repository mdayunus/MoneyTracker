//
//  Group+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 01/07/19.
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
    @NSManaged public var name: String
    @NSManaged public var lastEditedAt: Date
    @NSManaged public var groupMember: NSSet
    @NSManaged public var groupTransaction: NSSet

}

// MARK: Generated accessors for groupMember
extension Group {

    @objc(addGroupMemberObject:)
    @NSManaged public func addToGroupMember(_ value: Member)

    @objc(removeGroupMemberObject:)
    @NSManaged public func removeFromGroupMember(_ value: Member)

    @objc(addGroupMember:)
    @NSManaged public func addToGroupMember(_ values: NSSet)

    @objc(removeGroupMember:)
    @NSManaged public func removeFromGroupMember(_ values: NSSet)

}

// MARK: Generated accessors for groupTransaction
extension Group {

    @objc(addGroupTransactionObject:)
    @NSManaged public func addToGroupTransaction(_ value: Transaction)

    @objc(removeGroupTransactionObject:)
    @NSManaged public func removeFromGroupTransaction(_ value: Transaction)

    @objc(addGroupTransaction:)
    @NSManaged public func addToGroupTransaction(_ values: NSSet)

    @objc(removeGroupTransaction:)
    @NSManaged public func removeFromGroupTransaction(_ values: NSSet)

}
