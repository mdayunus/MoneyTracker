//
//  MemberInfo+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 14/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension MemberInfo {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<MemberInfo> {
        return NSFetchRequest<MemberInfo>(entityName: "MemberInfo")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var emailID: String
    @NSManaged public var id: String
    @NSManaged public var imageData: Data
    @NSManaged public var lastEditedAt: Date
    @NSManaged public var name: String
    @NSManaged public var info: Member

}
