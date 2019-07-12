//
//  MemberInfo+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 03/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension MemberInfo {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<MemberInfo> {
        return NSFetchRequest<MemberInfo>(entityName: "MemberInfo")
    }

    @NSManaged public var joiningDate: Date
    @NSManaged public var position: String
    @NSManaged public var member: Member
    @NSManaged public var ofGroup: Group
    @NSManaged public var transactions: NSSet

}

// MARK: Generated accessors for transactions
extension MemberInfo {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
