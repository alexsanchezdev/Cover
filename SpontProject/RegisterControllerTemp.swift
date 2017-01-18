//
//  RegisterController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 15/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class RegisterControllerTemp: UIRegisterViewTemp, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeImg = UIImage(named: "close_img")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeImg, style: .plain, target: self, action: #selector(closeRegister))
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let phone = phoneTextField.text else {
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile-images").child("\(imageName).jpeg")
            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if (error != nil){
                        print(error!)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "phone": phone, "profileImg": profileImageURL]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                    
                    print(metadata as Any)
                })
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]){
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            self.loginDismissRegister()
            print("Saved user successfully into Firebase!")
        })
    }

    func loginDismissRegister(){
        
//         Detect how  many layers of presentingViewController are, and dismiss view controllers depending on the amount.
        guard let pvc = self.presentingViewController?.presentingViewController else {
            return
        }
        
        if let _ = pvc.presentingViewController {
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func closeRegister(){
        dismiss(animated: true, completion: nil)
    }
    
}
