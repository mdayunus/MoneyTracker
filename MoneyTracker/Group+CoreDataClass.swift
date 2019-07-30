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
        for day in days{
            total = total + day.getTotalDebit()
        }
        return total
    }
    
    func getTotalCredit() -> Double{
        var total: Double = 0
        for day in days{
            total = total + day.getTotalCredit()
        }
        return total
    }
}
