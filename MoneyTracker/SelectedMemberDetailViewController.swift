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
    
    var selectedMemberInfo: MemberInfo?
    var groupArr = [Group]()
    var memberInfoArr = [Member]()
    
    
    // outlets
    
    @IBOutlet weak var backgroundView: UIView!{
        didSet{
            backgroundView.layer.cornerRadius = backgroundView.frame.size.height / 2
            backgroundView.layer.masksToBounds = true
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
        let memberDetail = selectedMemberInfo!.info
        memberInfoArr = Array(memberDetail)
        groupArr = memberInfoArr.map({$0.inGroup})
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
        cell.detailTextLabel?.text = "Joined on \(memberInfoArr[indexPath.row].joiningDate.DateInString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.memberTransactionDetailInGroupVC) as? MemberTransactionDetailInGroupViewController{
            dvc.selectedGroup = groupArr[indexPath.row]
            dvc.selectedMember = memberInfoArr[indexPath.row]
            print(memberInfoArr[indexPath.row])
            navigationController?.show(dvc, sender: self)
        }
    }
    
    
}
