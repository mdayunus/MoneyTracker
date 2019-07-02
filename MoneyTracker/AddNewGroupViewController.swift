//
//  AddNewGroupViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 25/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class AddNewGroupViewController: UIViewController {
    
    var container = AppDelegate.container
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.delegate = self
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if nameTextField.text!.isEmpty{
            Alert.textFieldIsEmpty(name: nameTextField, on: self)
        }else{
            guard let container = container else {return}
            let newGroup = Group(context: container.viewContext)
            newGroup.name = nameTextField.text ?? Date().description
            newGroup.id = UUID().uuidString
            newGroup.createdAt = Date()
            newGroup.lastEditedAt = Date()
            newGroup.groupMember = []
            newGroup.groupTransaction = []
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
