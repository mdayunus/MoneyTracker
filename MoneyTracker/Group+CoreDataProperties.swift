//
//  Group+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 14/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var name: String
    @NSManaged public var createdAt: Date
    @NSManaged public var lastEdited: Date
    @NSManaged public var id: String
    @NSManaged public var members: NSSet
    @NSManaged public var day: NSSet

}

// MARK: Generated accessors for members
extension Group {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: Member)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: Member)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

// MARK: Generated accessors for day
extension Group {

    @objc(addDayObject:)
    @NSManaged public func addToDay(_ value: Day)

    @objc(removeDayObject:)
    @NSManaged public func removeFromDay(_ value: Day)

    @objc(addDay:)
    @NSManaged public func addToDay(_ values: NSSet)

    @objc(removeDay:)
    @NSManaged public func removeFromDay(_ values: NSSet)

}
