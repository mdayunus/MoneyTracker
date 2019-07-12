//
//  Member+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 03/07/19.
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
    @NSManaged public var emailID: String
    @NSManaged public var id: String
    @NSManaged public var imageData: Data
    @NSManaged public var lastEditedAt: Date
    @NSManaged public var name: String
    @NSManaged public var info: NSSet

}

// MARK: Generated accessors for info
extension Member {

    @objc(addInfoObject:)
    @NSManaged public func addToInfo(_ value: MemberInfo)

    @objc(removeInfoObject:)
    @NSManaged public func removeFromInfo(_ value: MemberInfo)

    @objc(addInfo:)
    @NSManaged public func addToInfo(_ values: NSSet)

    @objc(removeInfo:)
    @NSManaged public func removeFromInfo(_ values: NSSet)

}
