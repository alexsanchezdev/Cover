//
//  LoginController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 12/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

extension LoginController {
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        bottomLoginConstraint.constant = -keyboardHeight
        centerTextfieldConstraint.constant = -(keyboardHeight/2)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification){
        bottomLoginConstraint.constant = 0
        centerTextfieldConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showRegisterForm(){
        let registerController = RegisterController()
        registerController.directRegister = false
        present(UINavigationController(rootViewController: registerController), animated: true, completion: nil)
    }
    
    func handleLogin(){
        activityIndicator.startAnimating()
        loginButton.setTitle("", for: .normal)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
        
            if error != nil {
                print(error!)
                self.errorMessageView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.loginButton.setTitle("Iniciar sesión", for: .normal)
                return
            }
            
            print("Succesfully logged in!")
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleRegister(){
        let registerController = UINavigationController(rootViewController: RegisterController())
        present(registerController, animated: true, completion: nil)
    }
    
    func resetWarning(){
        errorMessageView.isHidden = true
    }
}
