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
    
    var selectedDay: Day!
    
    var pContainer = AppDelegate.container
    var selectedGroup: Group?
    var selectedMember: Member!
    var cal = Calendar.current
    let uuidString = UUID().uuidString
    let current = UNUserNotificationCenter.current()
    let cdp = UIDatePicker()
    let todayComponent = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    
    
    // outlets
    
    @IBOutlet weak var amountTextField: UITextField!{
        didSet{
            amountTextField.delegate = self
        }
    }
    
    @IBOutlet weak var noteTextField: UITextField!{
        didSet{
            noteTextField.delegate = self
        }
    }
    
    @IBOutlet weak var cashOrChequeLabel: UILabel!
    
    @IBOutlet weak var cashOrCheque: UISwitch!
    
    @IBOutlet weak var chequeNumberField: UITextField!{
        didSet{
            chequeNumberField.isHidden = true
            chequeNumberField.delegate = self
        }
    }
    
    @IBOutlet weak var chequeDateField: UITextField!{
        didSet{
            chequeDateField.isHidden = true
            cdp.datePickerMode = .date
            chequeDateField.inputView = cdp
            let cdt = UIToolbar()
            cdt.sizeToFit()
            cdt.isUserInteractionEnabled = true
            cdt.setItems([UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateIsPicked))], animated: true)
            chequeDateField.inputAccessoryView = cdt
        }
    }
    
    @IBOutlet weak var remindLabel: UILabel!
    
    @IBOutlet weak var remind: UISwitch!{
        didSet{
            remind.setOn(false, animated: true)
        }
    }
    
    @IBOutlet weak var remindStack: UIStackView!{
        didSet{
            remindStack.isHidden = true
        }
    }
    
    
    // helper methods
    
    @objc func dateIsPicked(){
        print(cdp.date)
        chequeDateField.text = cdp.date.DateInString
        chequeDateField.resignFirstResponder()
    }
    
    func scheduleNotification(dateComponents: DateComponents, amount: Double, member: String, category: String){
        let content = UNMutableNotificationContent()
        content.title = "Debit Reminder"
        content.body = "Alert: today at \(String(describing: dateComponents.year)) \(String(describing: dateComponents.month)) \(String(describing: dateComponents.day)) \(String(describing: dateComponents.hour)) \(String(describing: dateComponents.minute)), \(amount) will be debited from \(member) account"
        content.sound = .default
        content.categoryIdentifier = category
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        //reminder actions
        //        let openAction = UNNotificationAction(identifier: "open", title: "open", options: [.foreground])
        //        let laterAction = UNNotificationAction(identifier: "later", title: "Remind me tomorrow", options: [])
        let closeAction = UNNotificationAction(identifier: "close", title: "close", options: [])
        
        let chequeNotificationActions = UNNotificationCategory(identifier: self.uuidString, actions: [/*openAction, laterAction,*/ closeAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [])
        
        current.setNotificationCategories([chequeNotificationActions])
        current.add(request) { (error) in
            if error != nil{
                print(error!)
            }else{
                print("succesfully created an alert")
            }
        }
    }
    
    
    // actions
    
    
    @IBAction func cashOrChequeAction(_ sender: UISwitch) {
        if sender.isOn{
            cashOrChequeLabel.text = "cash"
            chequeNumberField.isHidden = true
            chequeDateField.isHidden = true
            remindStack.isHidden = true
        }else{
            cashOrChequeLabel.text = "cheque"
            chequeNumberField.isHidden = false
            chequeDateField.isHidden = false
            remindStack.isHidden = false
        }
    }
    
    @IBAction func remindAction(_ sender: UISwitch) {
        if sender.isOn{
            remindLabel.text = "Remind me"
        }else{
            remindLabel.text = "don't Remind"
        }
    }
    
    
    @IBAction func saveTransaction(_ sender: UIButton) {
        guard let container = pContainer else{return}
        guard let group = selectedGroup  else {return}
        
        var cdc = cal.dateComponents([.day, .month, .year], from: cdp.date)
        guard let checkTime = cal.date(from: cdc) else{return}
        
        
        let days = group.days
        let dayArr = Array(days)
        let dayCount = dayArr.count
        if dayCount == 0{
            //            selectedDay = dayArr[0]
        }else{
            selectedDay = dayArr[dayCount - 1]
        }
        
        
        
        
        
        if !amountTextField.text!.isEmpty && !noteTextField.text!.isEmpty{
            if let amountInDouble = Double(amountTextField.text!){
                if cashOrCheque.isOn{
                    // cash is selected
                    // try to save here
                    if dayArr.isEmpty || selectedDay.day != todayComponent{
                        print("no day or selected day is not today")
                        let nt = Transaction(context: container.viewContext)
                        nt.cashOrCheque = CashOrCheque.cash.inString  //["cash"]
                        nt.creditOrDebit = true
                        nt.id = uuidString
                        nt.madeAt = Date()
                        //                        nt.byMember = memberList[indexPath.row]
                        let nDebit = Debit(context: container.viewContext)
                        nDebit.amount = amountInDouble //90
                        nDebit.purpose = noteTextField.text! //"this is a note"
                        nt.debit = nDebit
                        guard let sm = selectedMember else{return}
                        sm.totalmembercredit = sm.totalmembercredit + 0
                        sm.totalmemberdebit = sm.totalmemberdebit + nDebit.amount
                        nt.byMember = sm
                        let today = Day(context: container.viewContext)
                        today.day = todayComponent
                        today.totaldaycredit = 0
                        today.totaldaydebit = nDebit.amount
                        //                        today.invInGroup = group
                        let g = group
                        g.totalgroupdebit = nDebit.amount
                        g.totalgroupcredit = 0
                        today.invInGroup = g
                        today.transactions = []
                        nt.invOnDay = today
                        try? container.viewContext.save()
                        navigationController?.popViewController(animated: true)
                    }else if selectedDay.day == todayComponent{
                        print("some day")
                        print("already in day")
                        let nt = Transaction(context: container.viewContext)
                        nt.cashOrCheque = CashOrCheque.cash.inString  //["cash"]
                        nt.creditOrDebit = true
                        nt.id = uuidString
                        nt.madeAt = Date()
                        //                        nt.byMember = memberList[indexPath.row]
                        let nDebit = Debit(context: container.viewContext)
                        nDebit.amount = amountInDouble //90
                        nDebit.purpose = noteTextField.text! //"this is a note"
                        nt.debit = nDebit
                        guard let sm = selectedMember else{return}
                        sm.totalmembercredit = sm.totalmembercredit + 0
                        sm.totalmemberdebit = sm.totalmemberdebit + nDebit.amount
                        nt.byMember = sm
                        selectedDay.totaldaydebit = selectedDay.totaldaydebit + nDebit.amount
                        selectedDay.totaldaycredit = selectedDay.totaldaycredit + 0
                        let g = group
                        g.totalgroupdebit = g.totalgroupdebit + nDebit.amount
                        g.totalgroupcredit = g.totalgroupcredit + 0
                        //                        selectedDay.invInGroup = g
                        nt.invOnDay = selectedDay
                        try? container.viewContext.save()
                        navigationController?.popViewController(animated: true)
                    }
                }else if !cashOrCheque.isOn{
                    // cheque is selected
                    if !chequeNumberField.text!.isEmpty && !chequeDateField.text!.isEmpty{
                        if !remind.isOn{
                            //cheque is selected remainder is off
                            // save here
                            if dayArr.isEmpty || selectedDay.day != todayComponent{
                                print("no day or selected day is not today")
                                let nt = Transaction(context: container.viewContext)
                                nt.cashOrCheque = CashOrCheque.cheque(number: chequeNumberField.text!, time: checkTime, remainderUUID: uuidString).inString
                                nt.creditOrDebit = true
                                nt.id = uuidString
                                nt.madeAt = Date()
                                //                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = noteTextField.text! //"this is a note"
                                nt.debit = nDebit
                                guard let sm = selectedMember else{return}
                                sm.totalmembercredit = sm.totalmembercredit + 0
                                sm.totalmemberdebit = sm.totalmemberdebit + nDebit.amount
                                nt.byMember = sm
                                let today = Day(context: container.viewContext)
                                today.day = todayComponent
                                today.totaldaycredit = 0
                                today.totaldaydebit = nDebit.amount
                                let g = group
                                g.totalgroupcredit = g.totalgroupcredit + 0
                                g.totalgroupdebit = g.totalgroupdebit + nDebit.amount
                                today.invInGroup = g
                                today.addToTransactions(nt)
                                today.transactions = []
                                nt.invOnDay = today
                                try? container.viewContext.save()
                                navigationController?.popViewController(animated: true)
                            }else{
                                print("some day")
                                print("already in day")
                                let nt = Transaction(context: container.viewContext)
                                nt.cashOrCheque = CashOrCheque.cheque(number: chequeNumberField.text!, time: checkTime, remainderUUID: uuidString).inString
                                nt.creditOrDebit = true
                                nt.id = uuidString
                                nt.madeAt = Date()
                                //                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = noteTextField.text! //"this is a note"
                                nt.debit = nDebit
                                guard let sm = selectedMember else{return}
                                sm.totalmembercredit = sm.totalmembercredit + 0
                                sm.totalmemberdebit = sm.totalmemberdebit + nDebit.amount
                                nt.byMember = sm
                                selectedDay.totaldaydebit = selectedDay.totaldaydebit + nDebit.amount
                                selectedDay.totaldaycredit = selectedDay.totaldaycredit + 0
                                let g = group
                                g.totalgroupdebit = g.totalgroupdebit + nDebit.amount
                                g.totalgroupcredit = g.totalgroupcredit + 0
                                nt.invOnDay = selectedDay
                                try? container.viewContext.save()
                                navigationController?.popViewController(animated: true)
                            }
                        }else if remind.isOn{
                            // cheque is selected
                            // reminder is on
                            //save here
                            if dayArr.isEmpty || selectedDay.day != todayComponent{
                                print("no day or selected day is not today")
                                
                                let nt = Transaction(context: container.viewContext)
                                nt.cashOrCheque = CashOrCheque.cheque(number: chequeNumberField.text!, time: checkTime, remainderUUID: uuidString).inString
                                nt.creditOrDebit = true
                                nt.id = uuidString
                                nt.madeAt = Date()
                                //                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = noteTextField.text! //"this is a note"
                                nt.debit = nDebit
                                guard let sm = selectedMember else{return}
                                sm.totalmembercredit = sm.totalmembercredit + 0
                                sm.totalmemberdebit = sm.totalmemberdebit + nDebit.amount
                                nt.byMember = sm
                                let today = Day(context: container.viewContext)
                                today.day = todayComponent
                                today.totaldaycredit = 0
                                today.totaldaydebit = nDebit.amount
                                let g = group
                                g.totalgroupcredit = g.totalgroupcredit + 0
                                g.totalgroupdebit = g.totalgroupdebit + nDebit.amount
                                today.invInGroup = g
                                today.addToTransactions(nt)
                                today.transactions = []
                                nt.invOnDay = today
                                try? container.viewContext.save()
                                navigationController?.popViewController(animated: true)
                            }else{
                                print("some day")
                                print("already in day")
                                
                                let nt = Transaction(context: container.viewContext)
                                nt.cashOrCheque = CashOrCheque.cheque(number: chequeNumberField.text!, time: checkTime, remainderUUID: uuidString).inString
                                nt.creditOrDebit = true
                                nt.id = uuidString
                                nt.madeAt = Date()
                                //                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = noteTextField.text! //"this is a note"
                                nt.debit = nDebit
                                guard let sm = selectedMember else{return}
                                sm.totalmembercredit = sm.totalmembercredit + 0
                                sm.totalmemberdebit = sm.totalmemberdebit + nDebit.amount
                                nt.byMember = sm
                                selectedDay.totaldaydebit = selectedDay.totaldaydebit + nDebit.amount
                                selectedDay.totaldaycredit = selectedDay.totaldaycredit + 0
                                let g = group
                                g.totalgroupdebit = g.totalgroupdebit + nDebit.amount
                                g.totalgroupcredit = g.totalgroupcredit + 0
                                nt.invOnDay = selectedDay
                                
                                cdc.hour = Cheque.timeHour
                                cdc.minute = Cheque.timeMin
                                
                                current.getNotificationSettings { (ntfctnSetting) in
                                    switch ntfctnSetting.authorizationStatus{
                                    case .provisional, .authorized:
                                        print("auth")
                                        
                                        self.scheduleNotification(dateComponents: cdc, amount: nDebit.amount, member: nt.byMember.memberInfo.name, category: self.uuidString)
                                        
                                    case .denied:
                                        print("denied")
                                        print("ask to go to settings and allow notification")
                                    case .notDetermined:
                                        print("not det")
                                        print("show go to app setttings and allow notification then come back and save")
                                        self.current.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                                            if error != nil{
                                                print(error!)
                                            }else{
                                                if granted == false{
                                                    print("declined")
                                                }else if granted == true{
                                                    print("granted")
                                                    self.scheduleNotification(dateComponents: cdc, amount: nDebit.amount, member: nt.byMember.memberInfo.name, category: self.uuidString)
                                                }
                                            }
                                        })
                                    default:
                                        print("default")
                                    }
                                }
                                
                                
                                try? container.viewContext.save()
                                navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        // alert that date or number is empty
                        Alert.textFieldIsEmpty(name: chequeNumberField, chequeDateField, on: self)
                    }
                }
                
            }else{
                //alert amount is not a double
                Alert.stringCannotBeConvertedIntoDouble(on: self)
            }
        }
        else{
            //alert amount or purpose is empty
            Alert.textFieldIsEmpty(name: amountTextField, noteTextField, on: self)
        }
    }
    
    
    // view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
extension NewTransactionInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case amountTextField:
            amountTextField.resignFirstResponder()
            noteTextField.becomeFirstResponder()
            return true
        case noteTextField:
            noteTextField.resignFirstResponder()
            return true
        case chequeNumberField:
            chequeNumberField.resignFirstResponder()
            chequeDateField.becomeFirstResponder()
            return true
        default:
            return false
        }
    }
}
