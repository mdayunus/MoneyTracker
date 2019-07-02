//
//  SelectedMemberDetailViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 28/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class SelectedMemberDetailViewController: UIViewController {
    
    @IBOutlet weak var memberGroupTableView: UITableView!{
        didSet{
            memberGroupTableView.delegate = self
            memberGroupTableView.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let memberGroupSet = selectedMember?.inGroup as? Set<Group> else{return}
        groupArr = Array(memberGroupSet)
    }
    
    var selectedMember: Member?
    var groupArr = [Group]()


}

extension SelectedMemberDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberGroupTableView.dequeueReusableCell(withIdentifier: Cells.selectedMemberGroupCell, for: indexPath)
        cell.textLabel?.text = groupArr[indexPath.row].name
        cell.detailTextLabel?.text = groupArr[indexPath.row].createdAt.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.memberTransactionDetailInGroupVC) as? MemberTransactionDetailInGroupViewController{
            dvc.selectedMember = selectedMember
            dvc.selectedGroup = groupArr[indexPath.row]
            navigationController?.show(dvc, sender: self)
        }
    }
    
    
}
