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
    
    @IBOutlet weak var allMemberTableView: UITableView!{
        didSet{
            allMemberTableView.delegate = self
            allMemberTableView.dataSource = self
        }
    }
    
    @objc func getMember(){
        let req = Member.createFetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: container!.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        try? frc?.performFetch()
        allMemberTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "All Members"
        getMember()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "members: \(memberCount)", style: .plain, target: self, action: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getMember), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    var frc: NSFetchedResultsController<Member>?
    
    var container = AppDelegate.container
    
    var memberCount = 0

}

extension AllMemberViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memberCount = frc?.sections?[section].objects?.count ?? 0
        return frc?.sections?[section].objects?.count ?? 0
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allMemberTableView.dequeueReusableCell(withIdentifier: Cells.allMemberCell, for: indexPath)
        if let objc = frc?.object(at: indexPath){
            cell.textLabel?.text = objc.memberInfo.name
            cell.detailTextLabel?.text = objc.memberInfo.emailID
            cell.imageView?.image = UIImage(data: objc.memberInfo.imageData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: VCs.selectedMemberDetailVC) as? SelectedMemberDetailViewController{
            dvc.selectedMember = frc?.object(at: indexPath)
            navigationController?.show(dvc, sender: self)
        }
    }
    
    
}
