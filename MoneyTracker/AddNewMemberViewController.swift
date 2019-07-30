//
//  AddNewMemberViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 26/06/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit
import CoreData

class AddNewMemberViewController: UIViewController {
    
    
    // outlets
    
    var container = AppDelegate.container
    
    var selectedGroup: Group?
    
    lazy var imagePicker = UIImagePickerController()
    
    var imageData: Data?{
        didSet{
            memberImageView.image = UIImage(data: imageData!)
        }
    }
    
    
    // outlets
    
    @IBOutlet weak var memberImageView: UIImageView!{
        didSet{
            memberImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImportImageOptions)))
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.delegate = self
        }
    }
    
    
    // helper methods
    
    @objc func getImage(using source: UIImagePickerController.SourceType){
        imagePicker.sourceType = source
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func showImportImageOptions(){
        let alertController = UIAlertController(title: "Choose", message: "select from below", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "camera", style: .default, handler: {[weak self] (uiaa) in
            //use camera
            self?.getImage(using: .camera)
        }))
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {[weak self] (uiaa) in
            //use photo library
            self?.getImage(using: .photoLibrary)
        }))
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    // actions
    
    @IBAction func saveMember(_ sender: UIButton) {
        if emailTextField.text!.isEmpty || nameTextField.text!.isEmpty{
            Alert.textFieldIsEmpty(name: emailTextField, nameTextField, on: self)
        }else{
            if emailTextField.text!.validateEmail(){
                guard let defaultImageData = UIImage(named: "cash")?.pngData() else{return}
                guard let group = selectedGroup else{return}
                guard let container = container else{return}
                let nm = Member(context: container.viewContext)
                nm.joiningDate = Date()
                nm.position = "some position"
                nm.totalmemberdebit = 0
                nm.totalmembercredit = 0
                nm.inGroup = group
                
                let nmi = MemberInfo(context: container.viewContext)
                nmi.createdAt = Date()
                nmi.emailID = emailTextField.text!
                nmi.id = UUID().uuidString
                nmi.imageData = imageData ?? defaultImageData
                nmi.lastEditedAt = Date()
                nmi.name = nameTextField.text!
                nm.memberInfo = nmi
                
                nm.transactions = []
                
                group.addToMembers(nm)
                
                if container.viewContext.hasChanges{
                    do{
                        try container.viewContext.save()
                    }catch{
                        fatalError()
                    }
                }
                navigationController?.popViewController(animated: true)
            }else{
                print("invalid email")
            }
            
        }
    }
    
    
    
}
extension AddNewMemberViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            nameTextField.resignFirstResponder()
            switch emailTextField.text!.isEmpty{
            case true:
                emailTextField.becomeFirstResponder()
            case false:
                break
            }
            return true
        case emailTextField:
            emailTextField.resignFirstResponder()
            switch nameTextField.text!.isEmpty{
            case true:
                nameTextField.becomeFirstResponder()
            case false:
                break
            }
            return true
        default:
            return false
        }
    }
}
extension AddNewMemberViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imageData = image.jpegData(compressionQuality: 40)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension String{
    func validateEmail() -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
