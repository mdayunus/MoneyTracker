//
//  MyEnums.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 24/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import Foundation
import UIKit

struct JoiningDetail {
    var member: Member?
    var joiningDate: Date?
}

enum CashOrCheque{
    case cash
    case cheque(number: String, time: Date, remainderUUID: String)
    
    var inString: [String]{
        switch self {
        case .cash:
            return ["cash"]
        case let .cheque(number: num, time: time, remainderUUID: remainderString):
            return [num, time.description, remainderString]
        }
    }
}

enum CreditOrDebit: String{
    case credit
    case debit
}

struct Cheque {
    static let timeHour = 8
    static let timeMin = 30
}

struct VCs {
    static let mainVC = "mainVC"
    static let addNewGroupVC = "addNewGroupVC"
    static let groupTabBarController = "groupTabBarController"
    static let groupTransactionNavCon = "groupTransactionNavCon"
    static let groupVC = "groupVC"
    static let addNewTransactionVC = "addNewTransactionVC"
    static let groupMemberNavCon = "groupMemberNavCon"
    static let groupMemberVC = "groupMemberVC"
    static let addNewMemberVC = "addNewMemberVC"
    static let allExceptMemberVC = "allExceptMemberVC"
    static let allMemberVC = "allMemberVC"
    static let selectedMemberDetailVC = "selectedMemberDetailVC"
    static let memberTransactionDetailInGroupVC = "memberTransactionDetailInGroupVC"
    static let newTransactionInVC = "newTransactionInVC"
    static let selectedTransactionDetailTVC = "selectedTransactionDetailTVC"
    static let editMemberViewController = "editMemberViewController"
}

struct Segues {
    static let gotoAddNewTransaction = "gotoAddNewTransaction"
    static let gotoAddNewMember = "gotoAddNewMember"
}

struct Cells {
    static let groupCell = "groupCell"
    static let transactionCell = "transactionCell"
    static let optionCell = "optionCell"
    static let memberCell = "memberCell"
    static let allMemberCell = "allMemberCell"
    static let allExceptMemberCell = "allExceptMemberCell"
    static let selectedMemberGroupCell = "selectedMemberGroupCell"
    static let memberTransactionDetailInGroupCell = "memberTransactionDetailInGroupCell"
}

struct Alert {
    
    static func stringCannotBeConvertedIntoDouble(on vc: UIViewController){
        let alertController = UIAlertController(title: "Error", message: "the amount entered is not acceptable", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "try again", style: .default, handler: nil))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func textFieldIsEmpty(name field: UITextField..., on vc: UIViewController){
        let alertController = UIAlertController(title: "Error", message: "no field should be empty", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "try Again", style: .default, handler: nil)
        alertController.addAction(alertAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    static func viewContextDidNotSave(on vc: UIViewController){
        let alertController = UIAlertController(title: "No Changes", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func zeroMemberInGroup(on vc: UIViewController, with action: UIAlertAction){
        let alertController = UIAlertController(title: "No member", message: "you cannot add transaction is number of member in group is zero", preferredStyle: .alert)
    alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
}
