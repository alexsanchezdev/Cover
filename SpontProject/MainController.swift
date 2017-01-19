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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLoggedIn()
        OneSignal.promptLocation()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup methods
    
    let profileController = ProfileController()
    let messageController = MessagesController.sharedInstance
    
    func setupTabBar(){
        
        
        
        let message = UINavigationController(rootViewController: messageController)
        let search = UINavigationController(rootViewController: SearchController())
        let profile = UINavigationController(rootViewController: profileController)
        
        // Set UITabBar to not translucent
        tabBar.isTranslucent = false
        let imageInsets =   UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        // Set icons and insets for tab bar images
        message.tabBarItem.image = UIImage(named: "message_tabbar")?.withRenderingMode(.alwaysTemplate)
        message.tabBarItem.imageInsets = imageInsets
        //message.title = NSLocalizedString("Messages", comment: "Messages tab bar title")
        search.tabBarItem.image = UIImage(named: "search_tabbar")?.withRenderingMode(.alwaysTemplate)
        search.tabBarItem.imageInsets = imageInsets
        //search.title = NSLocalizedString("Search", comment: "Search tab bar title")
        profile.tabBarItem.image = UIImage(named: "profile_tabbar")?.withRenderingMode(.alwaysTemplate)
        profile.tabBarItem.imageInsets = imageInsets
        //profile.title = NSLocalizedString("Profile", comment: "Profile tab bar title")
        
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
            
            checkNotificationsIds()
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
    
    func checkNotificationsIds(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        
        OneSignal.idsAvailable({ (userId, pushToken) in
            
//            let notifRef = FIRDatabase.database().reference().child("notifications-user")
            let userRef = FIRDatabase.database().reference().child("notifications").child(uid)
            userRef.updateChildValues([userId!: 1])
//            notifRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                if snapshot.hasChild(userId!) {
//                    notifRef.child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
//                        if snapshot.key == userId {
//                            if snapshot.value as? String == uid {
//                                return
//                            } else {
//                                notifRef.updateChildValues([userId!: uid])
//                                userRef.updateChildValues([userId!: 1])
//                            }
//                        }
//                    }, withCancel: nil)
//                
//                } else {
//                    notifRef.updateChildValues([userId!: uid])
//                    userRef.updateChildValues([userId!: 1])
//                }
//            }, withCancel: nil)
            
//            
//            notifRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                if snapshot.key == userId {
//                    if snapshot.value as? String == uid {
//                        return
//                    }
//                
//                }
//            }, withCancel: nil)
//            
//            let ref = FIRDatabase.database().reference().child("user-notifications").child(uid!)
//            ref.updateChildValues([userId!: 1])
        })
    }
}

