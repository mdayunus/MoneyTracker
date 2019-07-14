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
    
    @IBOutlet weak var remind: UIStackView!{
        didSet{
            remind.isHidden = true
        }
    }
    let cdp = UIDatePicker()
    
    var cal = Calendar.current
    
    let current = UNUserNotificationCenter.current()
    
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
    
    @IBOutlet weak var creditOrDebitLabel: UILabel!
    
    @IBOutlet weak var creditOrDebit: UISwitch!
    
    @IBAction func creditOrDebitAction(_ sender: UISwitch) {
        if sender.isOn{
            creditOrDebitLabel.text = "debit"
        }else{
            creditOrDebitLabel.text = "credit"
        }
    }
    
    @IBOutlet weak var cashOrChequeLabel: UILabel!
    
    @IBOutlet weak var cashOrcheque: UISwitch!
    
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
    
    @IBOutlet weak var chequeNumberField: UITextField!{
        didSet{
            chequeNumberField.isHidden = true
            chequeNumberField.delegate = self
        }
    }
    
    @objc func dateIsPicked(){
        print(cdp.date)
        chequeDateField.text = cdp.date.DateInString
        chequeDateField.resignFirstResponder()
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
    
    @IBAction func remindMeAction(_ sender: UISwitch) {
        if sender.isOn{
            remindMeLabel.text = "Remind me"
        }else{
            remindMeLabel.text = "don't Remind"
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
    
    var memberInfoList = [MemberInfo]()
    
    var filteredMemberInfoList = [MemberInfo]()
    
    var container = AppDelegate.container
    
    let uuidString = UUID().uuidString
    
    
    var selectedGroup: Group?
    
    func scheduleNotification(dateComponents: DateComponents, amount: Double, member: String, cod: String, category: String){
        let content = UNMutableNotificationContent()
        content.title = "\(cod.uppercased()) Reminder"
        content.body = "Alert: today at \(String(describing: dateComponents.year)) \(String(describing: dateComponents.month)) \(String(describing: dateComponents.day)) \(String(describing: dateComponents.hour)) \(String(describing: dateComponents.minute)), \(amount) will be \(cod)ed to \(member) account"
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
        guard let memberSet = selectedGroup?.members as? Set<MemberInfo> else{return}
        memberInfoList = Array(memberSet)
        filteredMemberInfoList = Array(memberSet)
        if memberInfoList.isEmpty{
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

extension AddNewTransactionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: Cells.optionCell, for: indexPath)
        cell.textLabel?.text = memberInfoList[indexPath.row].name
        cell.detailTextLabel?.text = memberInfoList[indexPath.row].emailID
        cell.imageView?.image = UIImage(data: memberInfoList[indexPath.row].imageData)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let group = selectedGroup  else {return}
//        guard let container = container else{return}
//        let nt = Transaction(context: container.viewContext)
//        nt.id = uuidString
//        nt.madeAt = Date()
//        nt.byMember = memberInfoList[indexPath.row].info
//
//        guard let amountText = amountTextField.text, let noteOrPurposeText = noteOrPurpose.text else{return}
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
//                if !cashOrcheque.isOn{
//                    guard let chequeNumberText = chequeNumberField.text else{return}
//                    if chequeNumberText.isEmpty  || chequeDateField.text!.isEmpty{
//                        //show number and date are empty
//                        print("empty field/s here")
//                        Alert.textFieldIsEmpty(name: chequeNumberField, on: self)
//                        memberTableView.deselectRow(at: indexPath, animated: true)
//                    }else{
//
//
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
//
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
//                        }else if !remindMe.isOn{
//
//                            let cdc = cal.dateComponents([.day, .month, .year], from: cdp.date)
//                            guard let checkTime = cal.date(from: cdc) else{return}
//
//                            nt.cashOrCheque = CashOrCheque.cheque(number: chequeNumberText, time: checkTime, remainderUUID: "off").inString
////
////                            nt.id = uuidString
////                            nt.madeAt = Date()
////                            nt.byMember = memberInfoList[indexPath.row]
////                            nt.inGroup = group
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
//                }else if cashOrcheque.isOn{
//                    print(nt.noteOrPurpose)
//                    print(nt.amount)
//                    print(nt.creditOrDebit)
//                    nt.cashOrCheque = CashOrCheque.cash.inString
////                    nt.id = uuidString
////                    nt.madeAt = Date()
////                    nt.byMember = memberInfoList[indexPath.row]
////                    nt.inGroup = group
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
//    }
    
    
}
extension AddNewTransactionViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case amountTextField:
            amountTextField.resignFirstResponder()
//            switch noteOrPurpose.text!.isEmpty{
//            case true:
//                noteOrPurpose.becomeFirstResponder()
//            case false:
//                break
//            }
            noteOrPurpose.becomeFirstResponder()
            return true
        case noteOrPurpose:
            noteOrPurpose.resignFirstResponder()
//            chequeNumberField.becomeFirstResponder()
//            switch amountTextField.text!.isEmpty{
//            case true:
//                amountTextField.becomeFirstResponder()
//            case false:
//                break
//            }
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
            memberInfoList = filteredMemberInfoList
            memberTableView.reloadData()
            return
        }
        memberInfoList = filteredMemberInfoList.filter({ (mi) -> Bool in
            return mi.name.lowercased().contains(searchText.lowercased())
        })
        memberTableView.reloadData()
    }
}
