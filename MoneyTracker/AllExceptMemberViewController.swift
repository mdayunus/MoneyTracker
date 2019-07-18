//
//  AllMemberViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 27/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit
import CoreData

class AllExceptMemberViewController: UIViewController {
    
    
    // properties
    
    var frc: NSFetchedResultsController<MemberInfo>?
    
    var container = AppDelegate.container
    
    var selectedGroup: Group!
    
    var membersInGroup: [Member]!
    
    var allExceptMembers = [MemberInfo]()
    
    
    // outlets

    @IBOutlet weak var allExceptMemberTableView: UITableView!{
        didSet{
            allExceptMemberTableView.delegate = self
            allExceptMemberTableView.dataSource = self
        }
    }
    
    
    // view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let req = MemberInfo.createFetchRequest()
        guard let result = try? container?.viewContext.fetch(req) else{return}
        let memberInfoOfMembersInGroup = membersInGroup.map({$0.memberInfo})
        allExceptMembers = result.filter({element in
            return !memberInfoOfMembersInGroup.contains(element)
        })
    }

}
extension AllExceptMemberViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return allExceptMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allExceptMemberTableView.dequeueReusableCell(withIdentifier: Cells.allExceptMemberCell, for: indexPath)
        cell.textLabel?.text = allExceptMembers[indexPath.row].name
        cell.detailTextLabel?.text = allExceptMembers[indexPath.row].emailID
        cell.imageView?.image = UIImage(data: allExceptMembers[indexPath.row].imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let group = selectedGroup, let container = container else{return}
        let memberInfo = allExceptMembers[indexPath.row]
        let nm = Member(context: container.viewContext)
        nm.joiningDate = Date()
        nm.position = "some position"
        nm.inGroup = group
        nm.memberInfo = memberInfo
        nm.transactions = []
        group.addToMembers(nm)
        
        if container.viewContext.hasChanges{
            print("saving")
            do{
                try container.viewContext.save()
            }catch{
                fatalError()
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}
