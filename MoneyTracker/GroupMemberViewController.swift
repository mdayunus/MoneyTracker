//
//  GroupMemberViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 27/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class GroupMemberViewController: UIViewController {
    
    @IBOutlet weak var memberTableView: UITableView!{
        didSet{
            memberTableView.delegate = self
            memberTableView.dataSource = self
        }
    }
    
    func gotoCreateNewMemberVC(){
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.addNewMemberVC) as? AddNewMemberViewController{
            dvc.group = selectedGroup
            navigationController?.show(dvc, sender: self)
        }
    }
    
    func gotoAllExistingMembers(){
        //show list of all user
        print("all user")
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.allExceptMemberVC) as? AllExceptMemberViewController{
            dvc.group = selectedGroup
            dvc.membersInGroup = memberList
            navigationController?.show(dvc, sender: self)
        }
    }
    
    @IBAction func showOption(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Options", message: "select to proceed", preferredStyle: .actionSheet)
        let createNewAction = UIAlertAction(title: "Add New", style: .default) { [weak self] (uiaa) in
            self?.gotoCreateNewMemberVC()
            }
        alertController.addAction(createNewAction)
        let gotoAllMemberAction = UIAlertAction(title: "existing", style: .default) { [weak self] (uiaa) in
            self?.gotoAllExistingMembers()
        }
        alertController.addAction(gotoAllMemberAction)
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)

    }
    @objc func getMember(){
        guard let members = selectedGroup?.groupMember as? Set<Member> else{return}
        memberList = Array(members)
        memberTableView.reloadData()
    }
    
    var selectedGroup: Group?
    
    var memberList = [Member]()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let group = selectedGroup else{return}
        navigationItem.title = "Members in \(group.name)"
        getMember()
        NotificationCenter.default.addObserver(self, selector: #selector(getMember), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
 

}

extension GroupMemberViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: Cells.memberCell, for: indexPath)
        cell.textLabel?.text = memberList[indexPath.row].name
        cell.detailTextLabel?.text = memberList[indexPath.row].emailID
        cell.imageView?.image = UIImage(data: memberList[indexPath.row].imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.memberTransactionDetailInGroupVC) as? MemberTransactionDetailInGroupViewController{
            dvc.selectedMember = memberList[indexPath.row]
            dvc.selectedGroup = selectedGroup
            navigationController?.show(dvc, sender: self)
        }
        
    }
    
    
}