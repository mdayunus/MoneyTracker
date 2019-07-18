//
//  Member+CoreDataClass.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 16/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//
//

import Foundation
import CoreData


public class Member: NSManagedObject {
    func getTotalDebit(){
        var res: Double = 0
        for t in transactions{
            res = res + t.debit.amount
        }
    }
}
