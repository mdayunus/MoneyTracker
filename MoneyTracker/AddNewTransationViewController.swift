//
//  AddNewTransationViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 25/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit
import CoreData

class AddNewTransationViewController: UIViewController {
    
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
    
    @IBOutlet weak var cashOrcheque: UISwitch!
    
    @IBAction func cashOrChequeAction(_ sender: UISwitch) {
        if sender.isOn{
            cashOrChequeLabel.text = "cash"
        }else{
            cashOrChequeLabel.text = "cheque"
        }
    }
    
    @IBOutlet weak var creditOrDebitLabel: UILabel!
    
    @IBOutlet weak var inOrout: UISwitch!
    
    @IBAction func inOrOut(_ sender: UISwitch) {
        if sender.isOn{
            creditOrDebitLabel.text = "debit"
        }else{
            creditOrDebitLabel.text = "credit"
        }
    }
    
    @IBOutlet weak var memberTableView: UITableView!{
        didSet{
            memberTableView.delegate = self
            memberTableView.dataSource = self
        }
    }
    
    var memberList = [Member]()
    
    var container = AppDelegate.container
    
    var group: Group?
    
    func getMemberData(){
        guard let memberSet = group?.groupMember as? Set<Member> else{return}
        memberList = Array(memberSet)
        if memberList.isEmpty{
            let alertAction = UIAlertAction(title: "dismiss", style: .destructive) {[weak self] (uiaa) in
                self?.navigationController?.popViewController(animated: true)
            }
            Alert.zeroMemberInGroup(on: self, with: alertAction)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getMemberData()
    }

}

extension AddNewTransationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: Cells.optionCell, for: indexPath)
        cell.textLabel?.text = memberList[indexPath.row].name
        cell.detailTextLabel?.text = memberList[indexPath.row].emailID
        cell.imageView?.image = UIImage(data: memberList[indexPath.row].imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if amountTextField.text!.isEmpty || noteOrPurpose.text!.isEmpty{
            Alert.textFieldIsEmpty(name: amountTextField, noteOrPurpose, on: self)
        }else{
            if let amount = Double(amountTextField.text!){
                guard let container = container else{return}
                let nt = Transaction(context: container.viewContext)
                nt.amount = amount
                nt.id = UUID().uuidString
                nt.madeAt = Date()
                if cashOrcheque.isOn{
                    nt.cashOrCheque = CashOrCheque.cash.inString
                }else{
                    nt.cashOrCheque = CashOrCheque.cheque(number: "980890").inString
                }
                if inOrout.isOn{
                    nt.creditOrDebit = CreditOrDebit.debit.rawValue
                }else{
                    nt.creditOrDebit = CreditOrDebit.credit.rawValue
                }
                nt.noteOrPurpose = noteOrPurpose.text!
                nt.byMember = memberList[indexPath.row]
                nt.inGroup = group!
                if container.viewContext.hasChanges{
                    do{
                        try container.viewContext.save()
                    }catch{
                        fatalError()
                    }
                }
                navigationController?.popViewController(animated: true)
            }else{
                //show that string is not double
                Alert.stringCannotBeConvertedIntoDouble(on: self)
            }
        }
    }
    
    
}
extension AddNewTransationViewController: UITextFieldDelegate{
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
