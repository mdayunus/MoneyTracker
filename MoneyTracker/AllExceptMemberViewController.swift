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

    @IBOutlet weak var allExceptMemberTableView: UITableView!{
        didSet{
            allExceptMemberTableView.delegate = self
            allExceptMemberTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let req = Member.createFetchRequest()
        guard let result = try? container?.viewContext.fetch(req) else{return}
        guard let mig = membersInGroup else{return}
        allExceptMembers = result.filter({element in
            return !mig.contains(element)
        })
    }
    
    var frc: NSFetchedResultsController<Member>?
    
    var container = AppDelegate.container
    
    var group: Group?
    
    var membersInGroup: [Member]?
    
    var allExceptMembers = [Member]()
    

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
        guard let grp = group else{return}
        let member = allExceptMembers[indexPath.row]
        member.addToInGroup(grp)
        guard let container = container else{return}
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
