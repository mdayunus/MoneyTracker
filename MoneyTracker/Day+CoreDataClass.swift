//
//  Day+CoreDataClass.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 16/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


public class Day: NSManagedObject {
    func getTotalDebit() -> Double{
        var total: Double = 0
        for transaction in transactions{
            total = total + transaction.debit.amount
        }
        return total
    }
    
    func getTotalCredit() -> Double{
        var total: Double = 0
        for transaction in transactions{
            total = total + transaction.credit.amount
        }
        return total
    }

}
