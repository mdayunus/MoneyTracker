//
//  NewTransactionInViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 28/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class NewTransactionInViewController: UIViewController {
    
    // properties
    
    var container = AppDelegate.container
    var selectedGroup: Group?
    var selectedMemberInfo: MemberInfo!
    var cal = Calendar.current
    let uuidString = UUID().uuidString
    let current = UNUserNotificationCenter.current()
    
    // outlets
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var noteOrPurposeTextField: UITextField!
    
    @IBOutlet weak var creditOrDebitLabel: UILabel!
    
    @IBOutlet weak var creditOrDebit: UISwitch!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var cashOrChequeLabel: UILabel!
    
    @IBOutlet weak var cashOrCheque: UISwitch!
    
    @IBOutlet weak var chequeNumberField: UITextField!{
        didSet{
            chequeNumberField.isHidden = true
        }
    }
    
    @IBOutlet weak var chequeDateField: UITextField!{
        didSet{
            chequeDateField.isHidden = true
        }
    }
    
    @IBOutlet weak var remindLabel: UILabel!
    
    @IBOutlet weak var remind: UISwitch!
    
    @IBOutlet weak var remindStack: UIStackView!{
        didSet{
            remindStack.isHidden = true
        }
    }
    
    // actions
    
    
    @IBAction func creditOrDebitAction(_ sender: UISwitch) {
    }
    
    @IBAction func cashOrChequeAction(_ sender: UISwitch) {
        
    }
    
    @IBAction func remindAction(_ sender: UISwitch) {
    }
    
    
//    @IBAction func saveTransaction(_ sender: UIButton) {
//        
//        
//        guard let member = selectedMemberInfo else{return}
//        guard let group = selectedGroup  else {return}
//        guard let container = container else{return}
//        let nt = Transaction(context: container.viewContext)
//        
//        guard let amountText = amountTextField.text, let noteOrPurposeText = noteOrPurposeTextField.text else{return}
//        
//        if amountText.isEmpty || noteOrPurposeText.isEmpty{
//            Alert.textFieldIsEmpty(name: amountTextField, on: self)
//        }else{
//            if let amountInDouble = Double(amountText){
//                nt.amount = amountInDouble
//                
//                nt.noteOrPurpose = noteOrPurposeText
//                
//                nt.creditOrDebit = creditOrDebit.isOn ? CreditOrDebit.debit.rawValue : CreditOrDebit.credit.rawValue
//                
//                if !cashOrCheque.isOn{
//                    guard let chequeNumberText = chequeNumberField.text else{return}
//                    if chequeNumberText.isEmpty  || chequeDateField.text!.isEmpty{
//                        //show number and date are empty
//                        print("empty field/s here")
//                        Alert.textFieldIsEmpty(name: chequeNumberField, on: self)
//                        //                            memberTableView.deselectRow(at: indexPath, animated: true)
//                    }else{
//                        
//                        
//                        
//                        if remind.isOn{
//                            
//                            
//                            var cdc = cal.dateComponents([.day, .month, .year], from: cdp.date)
//                            
//                            //
//                            guard let checkTime = cal.date(from: cdc) else{return}
//                            
//                            //
//                            
//                            nt.cashOrCheque = CashOrCheque.cheque(number: chequeNumberText, time: checkTime, remainderUUID: uuidString).inString
//                            
//                            cdc.hour = Cheque.timeHour
//                            cdc.minute = Cheque.timeMin
//                            print(cdc)
//                            current.getNotificationSettings { (ntfctnSetting) in
//                                switch ntfctnSetting.authorizationStatus{
//                                case .provisional, .authorized:
//                                    print("auth")
//                                    
//                                    self.scheduleNotification(dateComponents: cdc, amount: nt.amount, member: nt.byMember.member.name, cod: nt.creditOrDebit, category: self.uuidString)
//                                    
//                                case .denied:
//                                    print("denied")
//                                    print("ask to go to settings and allow notification")
//                                case .notDetermined:
//                                    print("not det")
//                                    //                                                                print("show go to app setttings and allow notification then come back and save")
//                                    self.current.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
//                                        if error != nil{
//                                            print(error!)
//                                        }else{
//                                            if granted == false{
//                                                print("declined")
//                                            }else if granted == true{
//                                                print("granted")
//                                                self.scheduleNotification(dateComponents: cdc, amount: nt.amount, member: nt.byMember.member.name, cod: nt.creditOrDebit, category: self.uuidString)
//                                            }
//                                        }
//                                    })
//                                default:
//                                    print("default")
//                                }
//                            }
//                            
//                            
//                            nt.id = uuidString
//                            nt.madeAt = Date()
//                            nt.byMember = member
//                            nt.inGroup = group
//                            if container.viewContext.hasChanges{
//                                do{
//                                    try container.viewContext.save()
//                                    
//                                }catch{
//                                    print(error)
//                                    fatalError()
//                                }
//                            }
//                            navigationController?.popViewController(animated: true)
//                        }else if !remind.isOn{
//                            
//                            let cdc = cal.dateComponents([.day, .month, .year], from: cdp.date)
//                            guard let checkTime = cal.date(from: cdc) else{return}
//                            
//                            nt.cashOrCheque = CashOrCheque.cheque(number: chequeNumberText, time: checkTime, remainderUUID: "off").inString
//                            
//                            nt.id = uuidString
//                            nt.madeAt = Date()
//                            nt.byMember = member
//                            nt.inGroup = group
//                            if container.viewContext.hasChanges{
//                                do{
//                                    try container.viewContext.save()
//                                    
//                                }catch{
//                                    print(error)
//                                    fatalError()
//                                }
//                            }
//                            navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }else if cashOrCheque.isOn{
//                    print(nt.noteOrPurpose)
//                    print(nt.amount)
//                    print(nt.creditOrDebit)
//                    nt.cashOrCheque = CashOrCheque.cash.inString
//                    nt.id = uuidString
//                    nt.madeAt = Date()
//                    nt.byMember = member
//                    nt.inGroup = group
//                    if container.viewContext.hasChanges{
//                        do{
//                            try container.viewContext.save()
//                            
//                        }catch{
//                            fatalError()
//                        }
//                    }
//                    navigationController?.popViewController(animated: true)
//                }
//            }else{
//                // amount is not double
//                print("amount is not double")
//                Alert.stringCannotBeConvertedIntoDouble(on: self)
//            }
//        }
//        
//        
//        
//        
//        
//        
//        //
//    }
    
    
    
    
    
    
    
    // helper methods
    
    func scheduleNotification(dateComponents: DateComponents, amount: Double, member: String, cod: String, category: String){
        let content = UNMutableNotificationContent()
        content.title = "\(cod.uppercased()) Reminder"
        content.body = "Alert: today at \(String(describing: dateComponents.year)) \(String(describing: dateComponents.month)) \(String(describing: dateComponents.day)) \(String(describing: dateComponents.hour)) \(String(describing: dateComponents.minute)), \(amount) will be \(cod)ed to \(member) account"
        content.sound = .default
        content.categoryIdentifier = category
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        //reminder actions
        let openAction = UNNotificationAction(identifier: "open", title: "open", options: [.foreground])
        let laterAction = UNNotificationAction(identifier: "later", title: "Remind me tomorrow", options: [])
        let closeAction = UNNotificationAction(identifier: "close", title: "close", options: [])
        
        let chequeNotificationActions = UNNotificationCategory(identifier: self.uuidString, actions: [openAction, laterAction, closeAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [])
        
        current.setNotificationCategories([chequeNotificationActions])
        current.add(request) { (error) in
            if error != nil{
                print(error!)
            }else{
                print("succesfully created an alert")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let cdp = UIDatePicker()
    
    
    
    
    
    
    

}
extension NewTransactionInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case amountTextField:
            amountTextField.resignFirstResponder()
            switch noteOrPurposeTextField.text!.isEmpty{
            case true:
                noteOrPurposeTextField.becomeFirstResponder()
            case false:
                break
            }
            return true
        case noteOrPurposeTextField:
            noteOrPurposeTextField.resignFirstResponder()
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
