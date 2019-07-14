//
//  SelectedMemberDetailViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 28/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class SelectedMemberDetailViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundView: UIView!{
        didSet{
            backgroundView.layer.cornerRadius = backgroundView.frame.size.height / 2
            backgroundView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var memberImageView: UIImageView!
    
    @IBOutlet weak var memberName: UILabel!
    
    @IBOutlet weak var memberEmail: UILabel!
    
    @objc func viewSetup(){
        memberImageView.image = UIImage(data: selectedMember!.memberInfo.imageData)
        memberName.text = selectedMember?.memberInfo.name
        memberEmail.text = selectedMember?.memberInfo.emailID
    }
    
    @IBOutlet weak var memberGroupTableView: UITableView!{
        didSet{
            memberGroupTableView.delegate = self
            memberGroupTableView.dataSource = self
        }
    }
    
    @objc func editprofile(){
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.editMemberViewController) as? EditMemberViewController{
            dvc.selectedMember = selectedMember
            navigationController?.show(dvc, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        guard let memberDetail = selectedMember!.memberInfo as? Set<MemberInfo> else{return}
        memberInfoArr = Array(memberDetail)
//        groupArr = Array(memberDetail).map({$0.ofGroup})
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editprofile))
        NotificationCenter.default.addObserver(self, selector: #selector(viewSetup), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    var selectedMember: Member?
    var groupArr = [Group]()
    var memberInfoArr = [MemberInfo]()

}

extension SelectedMemberDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberGroupTableView.dequeueReusableCell(withIdentifier: Cells.selectedMemberGroupCell, for: indexPath)
        cell.textLabel?.text = groupArr[indexPath.row].name
        cell.detailTextLabel?.text = "Joined on \(memberInfoArr[indexPath.row].info.joiningDate.DateInString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.memberTransactionDetailInGroupVC) as? MemberTransactionDetailInGroupViewController{
//            guard let alltransaction = memberInfoArr[indexPath.row].transactions as? Set<Transaction> else{return}
//            dvc.allTransactions = Array(alltransaction)
            dvc.selectedGroup = groupArr[indexPath.row]
            dvc.selectedMemberInfo = memberInfoArr[indexPath.row]
            print(memberInfoArr[indexPath.row])
            navigationController?.show(dvc, sender: self)
        }
    }
    
    
}
