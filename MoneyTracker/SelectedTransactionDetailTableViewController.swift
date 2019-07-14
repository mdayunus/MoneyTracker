//
//  SelectedTransactionDetailTableViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 11/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class SelectedTransactionDetailTableViewController: UITableViewController {
    
    // properties
    
    var container = AppDelegate.container
    
    var selectedTransaction: Transaction!
    
    // outlets
    
    @IBOutlet weak var amountLabel: UILabel!
    
    
    @IBOutlet weak var noteLabel: UILabel!
    
    
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var methodLabel: UILabel!
    
    
    @IBOutlet weak var idLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var memberLabel: UILabel!
    
    
    @IBOutlet weak var groupLabel: UILabel!
    
    
    @IBOutlet weak var cnumberLabel: UILabel!
    
    
    @IBOutlet weak var cdateLabel: UILabel!
    
    
    @IBOutlet weak var reminderLabel: UILabel!
    
    
    // view controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Del", style: .plain, target: self, action: #selector(deleteThisTransaction))
        amountLabel.text = "\(selectedTransaction.debit.amount)"
        noteLabel.text = selectedTransaction.debit.purpose
//        typeLabel.text = selectedTransaction.creditOrDebit
        idLabel.text = selectedTransaction.id
        timeLabel.text = selectedTransaction.madeAt.DateInString
        memberLabel.text = selectedTransaction.byMember.memberInfo.name
        groupLabel.text = selectedTransaction.byMember.inGroup.name
        if selectedTransaction.cashOrCheque.count > 1{
            methodLabel.text = "cheque"
            cnumberLabel.text = selectedTransaction.cashOrCheque[0]
            cdateLabel.text = selectedTransaction.cashOrCheque[1]
            
            //start breaking check date
            
            
            
            
            
            
            
            //end of check date
            
            
            
            if selectedTransaction.cashOrCheque[2] == "off"{
                reminderLabel.text = "off"
            }else{
                reminderLabel.text = "on \(selectedTransaction.cashOrCheque[2])"
            }
        }else{
            methodLabel.text = "cash"
        }
    }
    
    // tableview delegate and datasoure
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            switch selectedTransaction.cashOrCheque.count{
            case 1:
                return 8
            default:
                return 11
            }
        default:
            return 0
        }
    }
    
    // helper methods
    
    @objc func deleteThisTransaction(){
        guard let pContainer = container else{return}
        pContainer.viewContext.delete(selectedTransaction)
        if pContainer.viewContext.hasChanges{
            do{
                try pContainer.viewContext.save()
                navigationController?.popViewController(animated: true)
            }catch{
                print("error in saving after delete")
                fatalError()
            }
        }
    }
    
}
