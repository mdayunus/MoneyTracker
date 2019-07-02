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
            dvc.selectedMember = selectedMember
            dvc.selectedGroup = selectedGroup
            navigationController?.show(dvc, sender: self)
        }
    }
    
    @objc func getTransactionData(){
        guard let transactionSet = selectedGroup?.groupTransaction as? Set<Transaction> else{return}
        let ta = Array(transactionSet)
        transactions = ta.filter({$0.byMember == selectedMember!})
        MemberTransactionDetailTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getTransactionData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewTransaction))
        NotificationCenter.default.addObserver(self, selector: #selector(getTransactionData), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    var selectedGroup: Group?
    var selectedMember: Member?
    var transactions = [Transaction]()

}
extension MemberTransactionDetailInGroupViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TransactionCell", owner: self, options: nil)?.first as? TransactionCell
        cell?.userImageView.image = UIImage(data: transactions[indexPath.row].byMember.imageData)
        cell?.memberName.text = transactions[indexPath.row].byMember.name
        if transactions[indexPath.row].creditOrDebit == CreditOrDebit.debit.rawValue{
            cell?.amount.textColor = UIColor.red
        }
        cell?.madeAt.text = transactions[indexPath.row].madeAt.description
        if transactions[indexPath.row].cashOrCheque == CashOrCheque.cash.inString{
            cell?.cocImageView.image = #imageLiteral(resourceName: "money")
        }else{
            cell?.cocImageView.image = #imageLiteral(resourceName: "check book")
        }
        cell?.amount.text = "\(transactions[indexPath.row].amount)"
        cell?.reason.text = transactions[indexPath.row].noteOrPurpose
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86.5
    }
    
    
}
