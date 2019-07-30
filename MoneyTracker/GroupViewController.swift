//
//  GroupViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 25/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit
import CoreData

class GroupViewController: UIViewController {
    
    //properties
    
    var daysInGroup = [Day]()
    
    var container = AppDelegate.container
    
    var selectedGroup: Group!
    
    
    // outlets
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 30
            containerView.layer.masksToBounds = true
            
            //            let gradient = CAGradientLayer()
            //            gradient.frame = containerView.bounds //self.view.bounds
            //            gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
            //            containerView.layer.addSublayer(gradient)
            //            self.view.layer.addSublayer(gradient)
            
        }
    }
    
    @IBOutlet weak var totalCreditLabel: UILabel!
    
    @IBOutlet weak var totalDebitLabel: UILabel!
    
    @IBOutlet weak var transactionsTableView: UITableView!{
        didSet{
            transactionsTableView.delegate = self
            transactionsTableView.dataSource = self
        }
    }
    
    
    // helper method
    
    @objc func getTransactionDetail(){
        let x = selectedGroup!.days
        daysInGroup = Array(x)
        //                daysInGroup.sort { (one, two) -> Bool in
        //                    return one.day > two.day
        //                }
        totalCreditLabel.text = "\(selectedGroup.getTotalCredit())"
        totalDebitLabel.text = "\(selectedGroup.getTotalDebit())"
        print(selectedGroup.totalgroupdebit)
        print(selectedGroup.totalgroupcredit)
        transactionsTableView.reloadData()
    }
    
    
    // actions
    
    @IBAction func closeGroup(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedGroup?.name
        getTransactionDetail()
        NotificationCenter.default.addObserver(self, selector: #selector(getTransactionDetail), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    
    // segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.gotoAddNewTransaction:
            if let dvc = segue.destination as? AddNewTransactionViewController{
                dvc.selectedGroup = selectedGroup
            }
        default:
            print("error in segue in groupViewController")
        }
    }
    
}
extension GroupViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return daysInGroup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysInGroup[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TransactionCell", owner: self, options: nil)?.first as! TransactionCell
        let tr = daysInGroup[indexPath.section].transactions
        let tra = Array(tr)
        let transaction = tra[indexPath.row]
        cell.userImageView.image = UIImage(data: transaction.byMember.memberInfo.imageData)
        cell.memberName.text = transaction.byMember.memberInfo.name
        if transaction.creditOrDebit == false{
            
            cell.amount.text = "\(transaction.credit.amount)"
            cell.reason.text = transaction.credit.note
        }else if transaction.creditOrDebit == true{
            cell.amount.textColor = UIColor.red
            cell.amount.text = "\(transaction.debit.amount)"
            cell.reason.text = transaction.debit.purpose
        }
        cell.madeAt.text = transaction.madeAt.DateInString
        if transaction.cashOrCheque == CashOrCheque.cash.inString{
            cell.cocImageView.image = #imageLiteral(resourceName: "money")
        }else{
            cell.cocImageView.image = #imageLiteral(resourceName: "check book")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //go to detail view and show detail of transaction
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.selectedTransactionDetailTVC) as? SelectedTransactionDetailTableViewController{
            let tr = daysInGroup[indexPath.section].transactions
            let tra = Array(tr)
            dvc.selectedTransaction = tra[indexPath.row]
            navigationController?.show(dvc, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        print(daysInGroup[section].day)
    //        return "\(Calendar.current.date(from: daysInGroup[section].day)!.DateInString) debit: \(daysInGroup[section].getTotalDebit())"
    //
    //    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)?.first as! SectionHeaderView
        v.dayLabel.text = "\(Calendar.current.date(from: daysInGroup[section].day)!.DateInString) \(daysInGroup[section].totaldaydebit)"
        //debit: \(daysInGroup[section].getTotalDebit())"
        return v
    }
    
    
}
