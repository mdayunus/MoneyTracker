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
    
    var transactionList = [Transaction]()
    
//    var frcTransactions: NSFetchedResultsController<Transaction>?

    @objc func getTransactionDetail(){
        guard let sgSet = selectedGroup?.groupTransaction as? Set<Transaction> else{return}
        transactionList = Array(sgSet)
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
            if let dvc = segue.destination as? AddNewTransationViewController{
                dvc.group = selectedGroup
            }
        default:
            print("error in segue in groupViewController")
        }
    }

}
extension GroupViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = transactionsTableView.dequeueReusableCell(withIdentifier: Cells.transactionCell, for: indexPath)
//        cell.textLabel?.text = "\(transactionList[indexPath.row].amount)"
//        cell.detailTextLabel?.text = "\(transactionList[indexPath.row].byMember.name)"
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TransactionCell", owner: self, options: nil)?.first as? TransactionCell
        cell?.userImageView.image = UIImage(data: transactionList[indexPath.row].byMember.imageData)
        cell?.memberName.text = transactionList[indexPath.row].byMember.name
        if transactionList[indexPath.row].creditOrDebit == CreditOrDebit.debit.rawValue{
            cell?.amount.textColor = UIColor.red
        }
        cell?.madeAt.text = transactionList[indexPath.row].madeAt.description
        if transactionList[indexPath.row].cashOrCheque == CashOrCheque.cash.inString{
            cell?.cocImageView.image = #imageLiteral(resourceName: "money")
        }else{
            cell?.cocImageView.image = #imageLiteral(resourceName: "check book")
        }
        cell?.amount.text = "\(transactionList[indexPath.row].amount)"
        cell?.reason.text = transactionList[indexPath.row].noteOrPurpose
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86.5
    }
    
    
}
