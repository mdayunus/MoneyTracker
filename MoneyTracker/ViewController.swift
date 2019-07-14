//
//  ViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 24/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    // properties
    
    let pContainer = AppDelegate.container
    
    var frcGroup: NSFetchedResultsController<Group>?
    
    
    // outlets
    
    @IBOutlet weak var groupTableView: UITableView!{
        didSet{
            groupTableView.delegate = self
            groupTableView.dataSource = self
        }
    }
    
    
    
    
    // helper methods
    
    @objc func getGroupData(){
        let request = Group.createFetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(key: "lastEditedAt", ascending: true)]
        guard let container = pContainer else{return}
        frcGroup = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try frcGroup?.performFetch()
        }catch{
            fatalError()
        }
        groupTableView.reloadData()
    }
    
    
    //  view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Groups"
        getGroupData()
        NotificationCenter.default.addObserver(self, selector: #selector(getGroupData), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frcGroup?.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        if let obj = frcGroup?.object(at: indexPath){
                
            cell.textLabel?.text = obj.name
            cell.detailTextLabel?.text = "created on: \(obj.createdAt.DateInString)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let groupTabBarController = storyboard?.instantiateViewController(withIdentifier: VCs.groupTabBarController) as? UITabBarController{
            if let groupNav = groupTabBarController.viewControllers?[0] as? UINavigationController{
                if let dvc = groupNav.visibleViewController as? GroupViewController{
                    dvc.selectedGroup = frcGroup?.object(at: indexPath)
                }
            }
            if let memberNav = groupTabBarController.viewControllers?[1] as? UINavigationController{
                if let dvc = memberNav.visibleViewController as? GroupMemberViewController{
                    dvc.selectedGroup = frcGroup?.object(at: indexPath)
                }
            }
            navigationController?.present(groupTabBarController, animated: true, completion: nil)
        }
    }
    
    
}
extension Date{
    var DateInString: String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
