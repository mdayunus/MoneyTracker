//
//  MemberTransactionDetailInGroupViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 28/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class MemberTransactionDetailInGroupViewController: UIViewController {
    
    
    // properties
    
    var allTransactions: [Transaction]?
    var selectedMember: Member!
    var selectedGroup: Group?
    
    
    // outlets
    
    @IBOutlet weak var backgroundView: UIView!{
        didSet{
            backgroundView.layer.cornerRadius = 20 //backgroundView.frame.height / 2
            backgroundView.layer.masksToBounds = true
        }
    }
    
    
    
    @IBOutlet weak var MemberTransactionDetailTableView: UITableView!{
        didSet{
            MemberTransactionDetailTableView.delegate = self
            MemberTransactionDetailTableView.dataSource = self
        }
    }
    
    
    // helper methods
    
    @objc func createNewTransaction(){
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.newTransactionInVC) as? NewTransactionInViewController{
            dvc.selectedMember = selectedMember
            dvc.selectedGroup = selectedGroup
            navigationController?.show(dvc, sender: self)
        }
    }
    
    @objc func getTransations(){
        let tset = selectedMember.transactions
        allTransactions = Array(tset)
        MemberTransactionDetailTableView.reloadData()
    }
    
    
    // view controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedMember.getTotalDebit())
        getTransations()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewTransaction))
        navigationItem.title = selectedGroup?.name
        NotificationCenter.default.addObserver(self, selector: #selector(getTransations), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    
}
extension MemberTransactionDetailInGroupViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTransactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TransactionCell", owner: self, options: nil)?.first as? TransactionCell
        cell?.userImageView.image = UIImage(data: (allTransactions?[indexPath.row].byMember.memberInfo.imageData)!)
        cell?.memberName.text = allTransactions?[indexPath.row].byMember.memberInfo.name
        cell?.madeAt.text = allTransactions?[indexPath.row].madeAt.description
        if allTransactions?[indexPath.row].cashOrCheque == CashOrCheque.cash.inString{
            cell?.cocImageView.image = #imageLiteral(resourceName: "money")
        }else{
            cell?.cocImageView.image = #imageLiteral(resourceName: "check book")
        }
        cell?.amount.text = "\(allTransactions![indexPath.row].debit.amount)"
        cell?.reason.text = allTransactions?[indexPath.row].debit.purpose
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
