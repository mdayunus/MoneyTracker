//
//  Member+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 29/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var joiningDate: Date
    @NSManaged public var position: String
    @NSManaged public var totalmembercredit: Double
    @NSManaged public var totalmemberdebit: Double
    @NSManaged public var inGroup: Group
    @NSManaged public var memberInfo: MemberInfo
    @NSManaged public var transactions: Set<Transaction>

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
