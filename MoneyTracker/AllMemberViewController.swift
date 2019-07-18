//
//  AllMemberViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 27/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit
import CoreData

class AllMemberViewController: UIViewController {
    
    
    // properties
    
    var frc: NSFetchedResultsController<MemberInfo>?
    
    var container = AppDelegate.container
    
    var memberCount = 0
    
    
    // outlets
    
    @IBOutlet weak var allMemberTableView: UITableView!{
        didSet{
            allMemberTableView.delegate = self
            allMemberTableView.dataSource = self
        }
    }
    
    
    // helper methods
    
    @objc func getMember(){
        let req = MemberInfo.createFetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: container!.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do{
                try frc?.performFetch()
        }catch{
            fatalError()
        }
        
        allMemberTableView.reloadData()
    }
    
    
    // view controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "All Members"
        getMember()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "members: \(memberCount)", style: .plain, target: self, action: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getMember), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    
}

extension AllMemberViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memberCount = frc?.sections?[section].objects?.count ?? 0
        return frc?.sections?[section].objects?.count ?? 0
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allMemberTableView.dequeueReusableCell(withIdentifier: Cells.allMemberCell, for: indexPath)
        if let objc = frc?.object(at: indexPath){
            cell.textLabel?.text = objc.name
            cell.detailTextLabel?.text = objc.emailID
            cell.imageView?.image = UIImage(data: objc.imageData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.selectedMemberDetailVC) as? SelectedMemberDetailViewController{
            dvc.selectedMemberInfo = frc?.object(at: indexPath)
            navigationController?.show(dvc, sender: self)
        }
    }
    
    
}
