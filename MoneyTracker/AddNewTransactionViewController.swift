//
//  AddNewTransationViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 25/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddNewTransactionViewController: UIViewController {
    
    
    // properties
    
    var selectedDay: Day!
    
    let cdp = UIDatePicker()
    
    var cal = Calendar.current
    
    let current = UNUserNotificationCenter.current()
    
    var memberList = [Member]()
    
    var filteredMemberInfoList = [Member]()
    
    var pContainer = AppDelegate.container
    
    let uuidString = UUID().uuidString
    
    var selectedGroup: Group?
    
    let todayComponent = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//    var selectedDate: Day?
    
    
    // outlets
    
    @IBOutlet weak var remind: UIStackView!{
        didSet{
            remind.isHidden = true
        }
    }
    
    
    @IBOutlet weak var amountTextField: UITextField!{
        didSet{
            amountTextField.delegate = self
        }
    }
    
    @IBOutlet weak var purposeTextField: UITextField!{
        didSet{
            purposeTextField.delegate = self
        }
    }
    
    @IBOutlet weak var cashOrChequeLabel: UILabel!
    
    @IBOutlet weak var cashOrcheque: UISwitch!
    
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
    
    @IBOutlet weak var remindMeLabel: UILabel!
    
    @IBOutlet weak var remindMe: UISwitch!{
        didSet{
            remindMe.setOn(false, animated: true)
        }
    }
    
    @IBOutlet weak var memberTableView: UITableView!{
        didSet{
            memberTableView.delegate = self
            memberTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var memberSearchBar: UISearchBar!{
        didSet{
            memberSearchBar.delegate = self
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
    
    func getMemberData(){
        let memberSet = selectedGroup?.members
        
        memberList = Array(memberSet!)
        filteredMemberInfoList = Array(memberSet!)
        if memberList.isEmpty{
            let alertAction = UIAlertAction(title: "dismiss", style: .destructive) {[weak self] (uiaa) in
                self?.navigationController?.popViewController(animated: true)
            }
            Alert.zeroMemberInGroup(on: self, with: alertAction)
        }
    }
    
    
    // actions
    
    @IBAction func cashOrChequeAction(_ sender: UISwitch) {
        
        if sender.isOn{
            cashOrChequeLabel.text = "cash"
            chequeNumberField.isHidden = true
            chequeDateField.isHidden = true
            remind.isHidden = true
        }else{
            cashOrChequeLabel.text = "cheque"
            chequeNumberField.isHidden = false
            chequeDateField.isHidden = false
            remind.isHidden = false
        }
    }
    
    @IBAction func remindMeAction(_ sender: UISwitch) {
        if sender.isOn{
            remindMeLabel.text = "Remind me"
        }else{
            remindMeLabel.text = "don't Remind"
        }
    }
    
    
    // view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMemberData()
    }

}

extension AddNewTransactionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: Cells.optionCell, for: indexPath)
        cell.textLabel?.text = memberList[indexPath.row].memberInfo.name
        cell.detailTextLabel?.text = memberList[indexPath.row].memberInfo.emailID
        cell.imageView?.image = UIImage(data: memberList[indexPath.row].memberInfo.imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
        
        
        
        
        if !amountTextField.text!.isEmpty && !purposeTextField.text!.isEmpty{
            if let amountInDouble = Double(amountTextField.text!){
                if cashOrcheque.isOn{
                    // cash is selected
                    // try to save here
                    if dayArr.isEmpty || selectedDay.day != todayComponent{
                        print("no day or selected day is not today")
                        let nt = Transaction(context: container.viewContext)
                        nt.cashOrCheque = CashOrCheque.cash.inString  //["cash"]
                        nt.creditOrDebit = true
                        nt.id = uuidString
                        nt.madeAt = Date()
                        nt.byMember = memberList[indexPath.row]
                        let nDebit = Debit(context: container.viewContext)
                        nDebit.amount = amountInDouble //90
                        nDebit.purpose = purposeTextField.text! //"this is a note"
                        nt.debit = nDebit
                        let today = Day(context: container.viewContext)
                        today.day = todayComponent
                        today.invInGroup = group
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
                        nt.byMember = memberList[indexPath.row]
                        let nDebit = Debit(context: container.viewContext)
                        nDebit.amount = amountInDouble //90
                        nDebit.purpose = purposeTextField.text! //"this is a note"
                        nt.debit = nDebit
                        nt.invOnDay = selectedDay
                        try? container.viewContext.save()
                        navigationController?.popViewController(animated: true)
                    }
                }else if !cashOrcheque.isOn{
                    // cheque is selected
                    if !chequeNumberField.text!.isEmpty && !chequeDateField.text!.isEmpty{
                        if !remindMe.isOn{
                            //cheque is selected remainder is off
                            // save here
                            if dayArr.isEmpty || selectedDay.day != todayComponent{
                                print("no day or selected day is not today")
                                let nt = Transaction(context: container.viewContext)
                                nt.cashOrCheque = CashOrCheque.cheque(number: chequeNumberField.text!, time: checkTime, remainderUUID: uuidString).inString
                                nt.creditOrDebit = true
                                nt.id = uuidString
                                nt.madeAt = Date()
                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = purposeTextField.text! //"this is a note"
                                nt.debit = nDebit
                                let today = Day(context: container.viewContext)
                                today.day = todayComponent
                                today.invInGroup = group
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
                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = purposeTextField.text! //"this is a note"
                                nt.debit = nDebit
                                nt.invOnDay = selectedDay
//                                selectedDay.invInGroup = group
                                try? container.viewContext.save()
                                navigationController?.popViewController(animated: true)
                            }
                        }else if remindMe.isOn{
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
                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = purposeTextField.text! //"this is a note"
                                nt.debit = nDebit
                                let today = Day(context: container.viewContext)
                                today.day = todayComponent
                                today.invInGroup = group
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
                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = purposeTextField.text! //"this is a note"
                                nt.debit = nDebit
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
            Alert.textFieldIsEmpty(name: amountTextField, purposeTextField, on: self)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        if dayArr.count == 0{
//            print("no day")
//            let nday = Day(context: container.viewContext)
//            nday.day = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//            nday.invInGroup = group
//            let nt = Transaction(context: container.viewContext)
//            nt.cashOrCheque = ["cash"]
//            nt.creditOrDebit = false
//            nt.id = "thisisanid"
//            nt.madeAt = Date()
//            nt.byMember = memberList[indexPath.row]
//            let nCredit = Credit(context: container.viewContext)
//            nCredit.amount = 90
//            nCredit.note = "this is a note"
//            nt.credit = nCredit
//            nday.addToTransactions(nt)
//            try? container.viewContext.save()
//            navigationController?.popViewController(animated: true)
//        }else{
//            print("some day")
//            let c = dayArr.count
//            let selectDay = dayArr[c-1]
//            if selectDay.day == Calendar.current.dateComponents([.year, .month, .day], from: Date()){
//                print("already in day")
//                let nt = Transaction(context: container.viewContext)
//                nt.cashOrCheque = ["cheque"]
//                nt.creditOrDebit = false
//                nt.id = "this is cheque wale trans ki id"
//                nt.madeAt = Date()
//                nt.byMember = memberList[indexPath.row]
////                let nCredit = Credit(context: container.viewContext)
////                nCredit.amount = 90
////                nCredit.note = "this is a note"
////                nt.credit = nCredit
//                let nDebit = Debit(context: container.viewContext)
//                nDebit.amount = 80
//                nDebit.purpose = "this is the purpose"
//                nt.debit = nDebit
//                nt.invOnDay = selectDay
////                selectDay.invInGroup = group
//
//                try? container.viewContext.save()
//                navigationController?.popViewController(animated: true)
//            }else{
//                print("not in day")
//                let nd = Day(context: container.viewContext)
//                nd.day = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//                nd.invInGroup = group
//                let nt = Transaction(context: container.viewContext)
//                nt.cashOrCheque = ["cash"]
//                nt.creditOrDebit = false
//                nt.id = "this s id"
//                nt.madeAt = Date()
//                nt.byMember = memberList[indexPath.row]
//                let nc = Credit(context: container.viewContext)
//                nc.amount = 77
//                nc.note = "hjgyu"
//                nt.credit = nc
//                nd.addToTransactions(nt)
//                try? container.viewContext.save()
//                navigationController?.popViewController(animated: true)
//            }
//        }
//        let lastDay = dayArr.last
        
        
        
//        let nt = Transaction(context: container.viewContext)
//        nt.creditOrDebit = false // change this to make switch off
//        nt.id = uuidString
//        nt.madeAt = Date()
//
//        nt.byMember = memberList[indexPath.row]
//        let ndebit = Debit(context: container.viewContext)
//        let onday = Day(context: container.viewContext)
//        onday.day = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//        onday.invInGroup = group
//        onday.transactions = [nt]
//
//
//        guard let amountText = amountTextField.text, let noteOrPurposeText = noteOrPurpose.text else{return}
//
//        if amountText.isEmpty || noteOrPurposeText.isEmpty{
//            Alert.textFieldIsEmpty(name: amountTextField, on: self)
//        }else{
//            if let amountInDouble = Double(amountText){
//                ndebit.amount = amountInDouble
//                ndebit.purpose = noteOrPurposeText
//
//
//                if !cashOrcheque.isOn{
//                    guard let chequeNumberText = chequeNumberField.text else{return}
//                    if chequeNumberText.isEmpty  || chequeDateField.text!.isEmpty{
//                        //show number and date are empty
//                        print("empty field/s here")
//                        Alert.textFieldIsEmpty(name: chequeNumberField, on: self)
//                        memberTableView.deselectRow(at: indexPath, animated: true)
//                    }else{
//
//                        if remindMe.isOn{
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
//                                    self.scheduleNotification(dateComponents: cdc, amount: ndebit.amount, member: nt.byMember.memberInfo.name, category: self.uuidString)
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
//                                                self.scheduleNotification(dateComponents: cdc, amount: ndebit.amount, member: nt.byMember.memberInfo.name, category: self.uuidString)
//                                            }
//                                        }
//                                    })
//                                default:
//                                    print("default")
//                                }
//                            }
//                            ndebit.amount = amountInDouble
//                            ndebit.purpose = noteOrPurposeText
//
//                            onday.transactions = [nt]
//                            if container.viewContext.hasChanges{
//                                do{
//                                    try container.viewContext.save()
//                                    print("saved 281")
//
//                                }catch{
//                                    print(error)
//                                    fatalError()
//                                }
//                            }
//                            navigationController?.popViewController(animated: true)
//                        }else if !remindMe.isOn{
//
//                            let cdc = cal.dateComponents([.day, .month, .year], from: cdp.date)
//                            guard let checkTime = cal.date(from: cdc) else{return}
//
//                            nt.cashOrCheque = CashOrCheque.cheque(number: chequeNumberText, time: checkTime, remainderUUID: "off").inString
//                            nt.debit = ndebit
//                            onday.transactions = [nt]
//                            if container.viewContext.hasChanges{
//                                do{
//                                    try container.viewContext.save()
//                                    print("saved 298")
//                                }catch{
//                                    print(error)
//                                    fatalError()
//                                }
//                            }
//                            navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }else if cashOrcheque.isOn{
//                    nt.cashOrCheque = CashOrCheque.cash.inString
//                    nt.debit = ndebit
//                    onday.transactions = [nt]
//                    if container.viewContext.hasChanges{
//                        do{
//                            try container.viewContext.save()
//                            print("saved 313")
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
    }
    
    
}
extension AddNewTransactionViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case amountTextField:
            amountTextField.resignFirstResponder()
            purposeTextField.becomeFirstResponder()
            return true
        case purposeTextField:
            purposeTextField.resignFirstResponder()
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
extension AddNewTransactionViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            memberList = filteredMemberInfoList
            memberTableView.reloadData()
            return
        }
        memberList = filteredMemberInfoList.filter({ (mi) -> Bool in
            return mi.memberInfo.name.lowercased().contains(searchText.lowercased())
        })
        memberTableView.reloadData()
    }
}
