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
    
    @IBOutlet weak var transactionsTableView: UITableView!{
        didSet{
            transactionsTableView.delegate = self
            transactionsTableView.dataSource = self
        }
    }
    @IBAction func closeGroup(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    var container = AppDelegate.container
    
    var selectedGroup: Group?

    @objc func getTransactionDetail(){
        guard let x = selectedGroup?.day as? Set<Day> else{return}
        daysInGroup = Array(x)
        daysInGroup.sort { (one, two) -> Bool in
            return one.day > two.day
        }
        transactionsTableView.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedGroup?.name
        getTransactionDetail()
        NotificationCenter.default.addObserver(self, selector: #selector(getTransactionDetail), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    
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
        guard let transaction = daysInGroup[indexPath.section].transactions[indexPath.row] as? Transaction else{return cell}
        cell.userImageView.image = UIImage(data: transaction.byMember.memberInfo.imageData)
        cell.memberName.text = transaction.byMember.memberInfo.name
//        if transactionList[indexPath.row].creditOrDebit == CreditOrDebit.debit.rawValue{
//            cell?.amount.textColor = UIColor.red
//        }
        cell.madeAt.text = transaction.madeAt.DateInString
        if transaction.cashOrCheque == CashOrCheque.cash.inString{
            cell.cocImageView.image = #imageLiteral(resourceName: "money")
        }else{
            cell.cocImageView.image = #imageLiteral(resourceName: "check book")
        }
        cell.amount.text = "\(transaction.debit.amount)"
        cell.reason.text = transaction.debit.purpose
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //go to detail view and show detail of transaction
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.selectedTransactionDetailTVC) as? SelectedTransactionDetailTableViewController{
            dvc.selectedTransaction = daysInGroup[indexPath.section].transactions[indexPath.row] as? Transaction
            navigationController?.show(dvc, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86.5
    }
    
    
}
