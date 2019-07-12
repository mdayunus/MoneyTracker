//
//  MemberTransactionDetailInGroupViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 28/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class MemberTransactionDetailInGroupViewController: UIViewController {
    
    
    
    @IBOutlet weak var MemberTransactionDetailTableView: UITableView!{
        didSet{
            MemberTransactionDetailTableView.delegate = self
            MemberTransactionDetailTableView.dataSource = self
        }
    }
    
    @objc func createNewTransaction(){
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.newTransactionInVC) as? NewTransactionInViewController{
            dvc.selectedMemberInfo = selectedMemberInfo
            dvc.selectedGroup = selectedGroup
            navigationController?.show(dvc, sender: self)
        }
    }
    
    @objc func getTransations(){
        guard let tset = selectedMemberInfo?.transactions as? Set<Transaction> else{return}
        allTransactions = Array(tset)
        MemberTransactionDetailTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getTransations()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewTransaction))
        navigationItem.title = selectedGroup?.name
        NotificationCenter.default.addObserver(self, selector: #selector(getTransations), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    var allTransactions: [Transaction]?
    var selectedMemberInfo: MemberInfo!
    var selectedGroup: Group?

}
extension MemberTransactionDetailInGroupViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTransactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TransactionCell", owner: self, options: nil)?.first as? TransactionCell
        cell?.userImageView.image = UIImage(data: (allTransactions?[indexPath.row].byMember.member.imageData)!)
        cell?.memberName.text = allTransactions?[indexPath.row].byMember.member.name
        if allTransactions?[indexPath.row].creditOrDebit == CreditOrDebit.debit.rawValue{
            cell?.amount.textColor = UIColor.red
        }
        cell?.madeAt.text = allTransactions?[indexPath.row].madeAt.description
        if allTransactions?[indexPath.row].cashOrCheque == CashOrCheque.cash.inString{
            cell?.cocImageView.image = #imageLiteral(resourceName: "money")
        }else{
            cell?.cocImageView.image = #imageLiteral(resourceName: "check book")
        }
        cell?.amount.text = "\(allTransactions![indexPath.row].amount)"
        cell?.reason.text = allTransactions?[indexPath.row].noteOrPurpose
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.selectedTransactionDetailTVC) as? SelectedTransactionDetailTableViewController{
            dvc.selectedTransaction = allTransactions?[indexPath.row]
            navigationController?.show(dvc, sender: self)
        }
    }
    
}
