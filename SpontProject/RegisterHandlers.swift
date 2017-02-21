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
            profilePicture.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func dismissRegisterController(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegister(){
        
        guard let name = nameTextField.text, !name.isEmpty else {
            let warning = UIAlertController(title: "Nombre no válido", message: "Debes de introducir un nombre para la cuenta.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            warning.addAction(ok)
            present(warning, animated: true, completion: nil)
            return
        }
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            let warning = UIAlertController(title: "Usuario no válido", message: "Debes de introducir un nombre de usuario.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            warning.addAction(ok)
            present(warning, animated: true, completion: nil)
            return
        }
        
        guard let password = passwordTextField.text, password.characters.count >= 6 else {
            let warning = UIAlertController(title: "Contraseña no válida", message: "La contraseña debe tener 6 o más carácteres alfanuméricos.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            warning.addAction(ok)
            present(warning, animated: true, completion: nil)
            return
        }
        
        guard let email = emailTextField.text, isValidEmail(email) else {
            let warning = UIAlertController(title: "Email no válido", message: "El correo electrónico introducido no es válido.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            warning.addAction(ok)
            present(warning, animated: true, completion: nil)
            return
        }
        
        guard let phone = phoneTextField.text, phone.characters.count == 9 else {
            let warning = UIAlertController(title: "Teléfono no válido", message: "Es necesario un teléfono de contacto para el registro.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            warning.addAction(ok)
            present(warning, animated: true, completion: nil)
            return
        }
        
        activityIndicator.startAnimating()
        registerButton.setTitle("", for: .normal)
        
        let ref = FIRDatabase.database().reference().child("usernames")
        ref.queryOrderedByKey().queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.activityIndicator.stopAnimating()
                        self.registerButton.setTitle("Iniciar sesión", for: .normal)
                        print(error!)
                        return
                    }
                    
                    guard let uid = user?.uid else {
                        return
                    }
                    
                    let imageName = NSUUID().uuidString
                    let storageRef = FIRStorage.storage().reference().child("profile-images").child("\(imageName).jpeg")
                    if let image = self.profilePicture.image {
                        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
                            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                                if error != nil {
                                    self.activityIndicator.stopAnimating()
                                    self.registerButton.setTitle("Iniciar sesión", for: .normal)
                                    print (error!)
                                    return
                                }
                                
                                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                                    let values = ["name": name, "email": email, "phone": "+34" + phone, "profileImg": profileImageURL, "username": username.lowercased()]
                                    
                                    let request = user?.profileChangeRequest()
                                    request?.displayName = name
                                    request?.photoURL = URL(fileURLWithPath: profileImageURL)
                                    request?.commitChanges(completion: { (error) in
                                        if error != nil {
                                            self.activityIndicator.stopAnimating()
                                            self.registerButton.setTitle("Iniciar sesión", for: .normal)
                                            print(error!)
                                        }
                                    })
                                    self.registerUserIntoDatabaseWithUID(uid, username: username, values: values as [String: AnyObject])
                                }
                            })
                        }
                    }
                    
                })
                
            } else {
                self.activityIndicator.stopAnimating()
                self.registerButton.setTitle("Iniciar sesión", for: .normal)
                print("Username already used")
                return
            }
        }, withCancel: nil)
        
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, username: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        let usernameReference = ref.child("usernames")
        let usernameUsersReference = ref.child("usernames-user")
        
        
        usersReference.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            usernameReference.updateChildValues([username: 1], withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                
                usernameUsersReference.updateChildValues([username: uid], withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    self.dissmissLoginController()
                })
            })
        }
    }
    
    func dissmissLoginController() {
        if directRegister {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func isValidEmail(_ email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}
