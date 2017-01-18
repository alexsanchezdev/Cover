//
//  MainController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 12/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class MainController: UITabBarController {
    
    // MARK: - Init methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        OneSignal.promptLocation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLoggedIn()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup methods
    
    let profileController = ProfileController()
    let messageController = MessagesController()
    
    func setupTabBar(){
        
        
        
        let message = UINavigationController(rootViewController: messageController)
        let search = UINavigationController(rootViewController: SearchController())
        let profile = UINavigationController(rootViewController: profileController)
        
        // Set UITabBar to not translucent
        tabBar.isTranslucent = false
        
        // Set icons and insets for tab bar images
        message.tabBarItem.image = UIImage(named: "message_tabbar")?.withRenderingMode(.alwaysTemplate)
        message.title = NSLocalizedString("Messages", comment: "Messages tab bar title")
        search.tabBarItem.image = UIImage(named: "search_tabbar")?.withRenderingMode(.alwaysTemplate)
        search.title = NSLocalizedString("Search", comment: "Search tab bar title")
        profile.tabBarItem.image = UIImage(named: "profile_tabbar")?.withRenderingMode(.alwaysTemplate)
        profile.title = NSLocalizedString("Profile", comment: "Profile tab bar title")
        
        // Assing controllers
        viewControllers = [message, search, profile]
        
        self.selectedIndex = 1
    }
    
    // MARK: - Auth state methods
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            handleLogout()
        } else {
            messageController.messages.removeAll()
            messageController.messagesDictionary.removeAll()
            messageController.tableView.reloadData()
            
            messageController.observeUserMessages()
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            OneSignal.idsAvailable({ (userId, pushToken) in
                let ref = FIRDatabase.database().reference().child("notifications")
                ref.updateChildValues([uid! : userId!])
            })
        }
    }
    func handleLogout(){
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let landingController = LandingController()
        present(landingController, animated: true, completion: nil)
    }
}

