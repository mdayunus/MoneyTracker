//
//  EditMemberViewController.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 11/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class EditMemberViewController: UIViewController {
    
    // properties
    
    var container = AppDelegate.container
    
    var selectedMemberInfo: MemberInfo!{
        didSet{
            print(selectedMemberInfo.name)
            do{
                try selectedMemberInfo.validateForUpdate()
            }catch{
                print("not valid for update")
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    lazy var imagePicker = UIImagePickerController()
    
    var imageData = Data()
    
    // outlets
    
    @IBOutlet weak var memberImageView: UIImageView!{
        didSet{
            memberImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageSelectionOption)))
        }
    }
    
    @IBOutlet weak var memberIDLabel: UILabel!
    
    @IBOutlet weak var memberCreatedAtLabel: UILabel!
    
    @IBOutlet weak var memberNewNameTextField: UITextField!
    
    @IBOutlet weak var memberNewEmailTextField: UITextField!
    
    @IBOutlet weak var memberLastEditedAtLabel: UILabel!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    
    // helper methods
    
    @objc func imageSelectionOption(){
        
        let alertCont = UIAlertController(title: "Choose", message: "to change profile picture", preferredStyle: .actionSheet)
        alertCont.addAction(UIAlertAction(title: "photo library", style: .default, handler: { (uiaa) in
            //
            self.getImage(with: .photoLibrary)
        }))
        alertCont.addAction(UIAlertAction(title: "camera", style: .default, handler: { (uiaa) in
            //
            self.getImage(with: .camera)
        }))
        alertCont.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alertCont, animated: true, completion: nil)
    }
    
    func getImage(with selectedtype: UIImagePickerController.SourceType){
        imagePicker.sourceType = selectedtype
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // actions
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        guard let pContainer = container else{return}
        guard let newEmail = memberNewEmailTextField.text, let newName = memberNewNameTextField.text else{return}
        
        if !newName.isEmpty{
            selectedMemberInfo.setValue(newName, forKey: "name")
            selectedMemberInfo.lastEditedAt = Date()
        }
        
        if !newEmail.isEmpty{
            if newEmail.validateEmail(){
                selectedMemberInfo.setValue(newEmail, forKey: "emailID")
                selectedMemberInfo.lastEditedAt = Date()
            }
        }
        
        if !imageData.isEmpty{
            selectedMemberInfo.setValue(imageData, forKey: "imageData")
            selectedMemberInfo.lastEditedAt = Date()
        }
        
        if pContainer.viewContext.hasChanges{
            do{
                try pContainer.viewContext.save()
                navigationController?.popViewController(animated: true)
            }catch{
                fatalError()
            }
        }
    }
    
    
    // view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageData.isEmpty)
        memberImageView.image = UIImage(data: selectedMemberInfo.imageData)
        memberIDLabel.text = selectedMemberInfo.id
        memberCreatedAtLabel.text = selectedMemberInfo.createdAt.DateInString
        memberNewNameTextField.placeholder = selectedMemberInfo.name
        memberNewEmailTextField.placeholder = selectedMemberInfo.emailID
        memberLastEditedAtLabel.text = selectedMemberInfo.lastEditedAt.DateInString
        alertLabel.text = "Tap on Image to change"
    }
    
    
}


extension EditMemberViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[.originalImage] as? UIImage{
            if let newImageData = imagePicked.jpegData(compressionQuality: 40){
                imageData = newImageData
                memberImageView.image = UIImage(data: imageData)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
