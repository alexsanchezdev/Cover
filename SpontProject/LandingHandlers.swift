//
//  LandingController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 19/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

extension LandingController {
    
    func showLogin(){
        
        print("Login button pressed!")
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func showRegister(){
        print("Register button pressed!")
        
        let registerController = UINavigationController(rootViewController: RegisterController())
        present(registerController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid != nil {
            print("Is this other one called?")
            let navigationController = UINavigationController(rootViewController: MainController())
            present(navigationController, animated: true, completion: nil)
        }
    }
}
