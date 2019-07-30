//
//  SelectedMemberDetailViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 28/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class SelectedMemberDetailViewController: UIViewController {
    
    
    // properties
    
    var selectedMemberInfo: MemberInfo!
    var groupArr = [Group]()
    var memberArr = [Member]()
    
    var totalDebit: Double = 0
    var totalCredit: Double = 0
    
    
    // outlets
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 24
            containerView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var totalCreditLabel: UILabel!{
        didSet{
            totalCreditLabel.text = "\(totalCredit)"
        }
    }
    
    @IBOutlet weak var totalDebitLabel: UILabel!{
        didSet{
            totalDebitLabel.text = "\(totalDebit)"
        }
    }
    
    @IBOutlet weak var memberImageView: UIImageView!
    
    @IBOutlet weak var memberName: UILabel!
    
    @IBOutlet weak var memberEmail: UILabel!
    
    @IBOutlet weak var memberGroupTableView: UITableView!{
        didSet{
            memberGroupTableView.delegate = self
            memberGroupTableView.dataSource = self
        }
    }
    
    
    // helper methods
    
    @objc func viewSetup(){
        memberImageView.image = UIImage(data: selectedMemberInfo!.imageData)
        memberName.text = selectedMemberInfo?.name
        memberEmail.text = selectedMemberInfo?.emailID
        let memberDetail = selectedMemberInfo!.info
        memberArr = Array(memberDetail)
        groupArr = memberArr.map({$0.inGroup})
        for member in memberArr{
            totalDebit = totalDebit + member.getTotalDebit()
            totalCredit = totalCredit + member.getTotalCredit()
        }
        totalDebitLabel.text = "\(totalDebit)"
        totalCreditLabel.text = "\(totalCredit)"
        
    }
    
    @objc func editprofile(){
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.editMemberViewController) as? EditMemberViewController{
            dvc.selectedMemberInfo = selectedMemberInfo
            navigationController?.show(dvc, sender: self)
        }
    }
    
    
    // view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editprofile))
        NotificationCenter.default.addObserver(self, selector: #selector(viewSetup), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    
    
}

extension SelectedMemberDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberGroupTableView.dequeueReusableCell(withIdentifier: Cells.selectedMemberGroupCell, for: indexPath)
        cell.textLabel?.text = groupArr[indexPath.row].name
        cell.detailTextLabel?.text = "Joined on \(memberArr[indexPath.row].joiningDate.DateInString)    \(memberArr[indexPath.row].getTotalDebit())"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.memberTransactionDetailInGroupVC) as? MemberTransactionDetailInGroupViewController{
            dvc.selectedGroup = groupArr[indexPath.row]
            dvc.selectedMember = memberArr[indexPath.row]
            navigationController?.show(dvc, sender: self)
        }
    }
    
    
}
