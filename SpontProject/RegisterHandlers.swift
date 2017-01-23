//
//  RegisterHandlers.swift
//  SpontProject
//
//  Created by Alex Sanchez on 26/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import Foundation
import Firebase

extension RegisterController {
    
    func handleSelectProfileImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        
        let optionMenu = UIAlertController(title: "Cambiar foto de perfil", message: nil, preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "Elegir de la fototeca", style: .default, handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        })
        let takePhoto = UIAlertAction(title: "Hacer foto", style: .default, handler: { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(photoLibrary)
        optionMenu.addAction(cancel)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point: CGPoint = CGPoint(x: 0, y: textField.frame.origin.y - 128)
        print(view.center.y)
        
        if point.y > 0 {
            registerScrollView.setContentOffset(point, animated: true)
        } else {
            registerScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func closeRegister(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegister(){
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            print("Username nil")
            usernameTextField.becomeFirstResponder()
            return
        }
        
        guard let password = passwordTextField.text, password.characters.count > 4 else {
            print("Contraseña muy corta")
            return
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            print("Name nil")
            return
        }
        
        guard let email = emailTextField.text, isValidEmail(email) else {
            print("Email error")
            return
        }
        
        guard let phone = phoneTextField.text, phone.characters.count == 9 else {
            print("Phone error")
            return
        }
        
        if isAvailable(username) {
        
        }
        
        
        
    }
    
    func isAvailable(_ username: String) -> Bool {
        var available: Bool?
        
        let ref = FIRDatabase.database().reference().child("usernames")
        ref.queryOrderedByKey().queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("Username available")
                available = true
                
            } else {
                print("Username already used")
                available = false
            }
        }, withCancel: nil)
        
        if let result = available {
            return result
        } else {
            return false
        }
    }
    
    func isValidEmail(_ email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}
