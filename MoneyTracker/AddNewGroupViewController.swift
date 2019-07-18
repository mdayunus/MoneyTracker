//
//  AddNewGroupViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 25/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class AddNewGroupViewController: UIViewController {
    
    
    // properties
    
    var pContainer = AppDelegate.container
    
    
    // outlets
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.delegate = self
        }
    }
    
    
    // actions
    
    @IBAction func saveButton(_ sender: UIButton) {
        if nameTextField.text!.isEmpty{
            Alert.textFieldIsEmpty(name: nameTextField, on: self)
        }else{
            guard let container = pContainer else {return}
            let newGroup = Group(context: container.viewContext)
            newGroup.createdAt = Date()
            newGroup.id = UUID().uuidString
            newGroup.lastEdited = Date()
            newGroup.name = nameTextField.text!
            newGroup.days = []
            newGroup.members = []
            if container.viewContext.hasChanges{
                do{
                    try container.viewContext.save()
                }catch{
                    fatalError()
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
    

}
extension AddNewGroupViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            nameTextField.resignFirstResponder()
            return true
        default:
            print("error")
            return true
        }
    }
}
