//
//  NewTransactionInViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 28/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit
import CoreData

class NewTransactionInViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!{
        didSet{
            amountTextField.delegate = self
        }
    }
    
    @IBOutlet weak var noteOrPurpose: UITextField!{
        didSet{
            noteOrPurpose.delegate = self
        }
    }
    
    @IBOutlet weak var cashOrChequeLabel: UILabel!
    
    @IBOutlet weak var cashOrCheque: UISwitch!
    
    @IBAction func cashOrChequeAction(_ sender: UISwitch) {
        if sender.isOn{
            cashOrChequeLabel.text = "cash"
        }else{
            cashOrChequeLabel.text = "cheque"
        }
    }
    
    @IBOutlet weak var creditOrDebitLabel: UILabel!
    
    @IBOutlet weak var inOrOut: UISwitch!
    
    @IBAction func creditOrDebitAction(_ sender: UISwitch) {
        if sender.isOn{
            creditOrDebitLabel.text = "debit"
        }else{
            creditOrDebitLabel.text = "credit"
        }
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        if amountTextField.text!.isEmpty || noteOrPurpose.text!.isEmpty{
            Alert.textFieldIsEmpty(name: amountTextField, noteOrPurpose, on: self)
        }else{
            if let amount = Double(amountTextField.text!){
                guard let container = container else{return}
                let nt = Transaction(context: container.viewContext)
                nt.amount = amount
                nt.id = UUID().uuidString
                nt.madeAt = Date()
                if cashOrCheque.isOn{
                    nt.cashOrCheque = CashOrCheque.cash.inString
                }else{
                    nt.cashOrCheque = CashOrCheque.cheque(number: "123").inString
                }
                if inOrOut.isOn{
                    nt.creditOrDebit = CreditOrDebit.debit.rawValue
                }else{
                    nt.creditOrDebit = CreditOrDebit.credit.rawValue
                }
                nt.noteOrPurpose = noteOrPurpose.text!
                nt.byMember = selectedMember!
                nt.inGroup = selectedGroup!
                if container.viewContext.hasChanges{
                    do{
                        try container.viewContext.save()
                    }catch{
                        fatalError()
                    }
                }
                navigationController?.popViewController(animated: true)
            }else{
                Alert.stringCannotBeConvertedIntoDouble(on: self)
            }
        }
    }
    
    var container = AppDelegate.container
    var selectedGroup: Group?
    var selectedMember: Member?

}
extension NewTransactionInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case amountTextField:
            amountTextField.resignFirstResponder()
            switch noteOrPurpose.text!.isEmpty{
            case true:
                noteOrPurpose.becomeFirstResponder()
            case false:
                break
            }
            return true
        case noteOrPurpose:
            noteOrPurpose.resignFirstResponder()
            switch amountTextField.text!.isEmpty{
            case true:
                amountTextField.becomeFirstResponder()
            case false:
                break
            }
            return true
        default:
            return false
        }
    }
}
