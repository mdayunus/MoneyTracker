//
//  Group+CoreDataClass.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 16/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


public class Group: NSManagedObject {
    
    func getTotalDebit() -> Double{
        var total: Double = 0
        for d in days{
            for t in d.transactions{
                print(t.debit.amount)
                total = total + t.debit.amount
            }
        }
        return total
    }
}
