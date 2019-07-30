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
                        //                        nt.byMember = memberList[indexPath.row]
                        let nDebit = Debit(context: container.viewContext)
                        nDebit.amount = amountInDouble //90
                        nDebit.purpose = purposeTextField.text! //"this is a note"
                        nt.debit = nDebit
                        let sm = memberList[indexPath.row]
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
                        nDebit.purpose = purposeTextField.text! //"this is a note"
                        nt.debit = nDebit
                        let sm = memberList[indexPath.row]
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
                                //                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = purposeTextField.text! //"this is a note"
                                nt.debit = nDebit
                                let sm = memberList[indexPath.row]
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
                                nDebit.purpose = purposeTextField.text! //"this is a note"
                                nt.debit = nDebit
                                let sm = memberList[indexPath.row]
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
                                //                                nt.byMember = memberList[indexPath.row]
                                let nDebit = Debit(context: container.viewContext)
                                nDebit.amount = amountInDouble //90
                                nDebit.purpose = purposeTextField.text! //"this is a note"
                                nt.debit = nDebit
                                let sm = memberList[indexPath.row]
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
                                nDebit.purpose = purposeTextField.text! //"this is a note"
                                nt.debit = nDebit
                                let sm = memberList[indexPath.row]
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
            Alert.textFieldIsEmpty(name: amountTextField, purposeTextField, on: self)
        }
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
