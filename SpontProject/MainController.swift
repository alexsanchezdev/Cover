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
import MapKit
import AudioToolbox

class MainController: UITabBarController, CLLocationManagerDelegate {
    
    public let newMessageIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 2
        return view
    }()
    
    // MARK: - Init methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        defaults.set(true, forKey: "firstLoad")
        
        let logo = UIImage(named: "logo_navbar")
        navigationItem.titleView = UIImageView(image: logo)
        
        
        
        view.backgroundColor = UIColor.white
        tabBar.addSubview(newMessageIndicator)
        newMessageIndicator.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        newMessageIndicator.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: -3).isActive = true
        newMessageIndicator.widthAnchor.constraint(equalToConstant: 4).isActive = true
        newMessageIndicator.heightAnchor.constraint(equalToConstant: 4).isActive = true
        newMessageIndicator.isHidden = true
        
        
        fetchUserData()
        
        Filters.sharedInstance.locationManager.delegate = self
        Filters.sharedInstance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        Filters.sharedInstance.locationManager.startUpdatingLocation()
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    // MARK: - Setup methods
    
    let profileController = ProfileController()
    let messageController = MessagesController.sharedInstance
    var currentUser = User()
    var tempTags = [String]()
    var tempVerified = [Int]()
    let group = DispatchGroup()
    
    func setupTabBar(){
        
        profileController.navigationItem.title = self.currentUser.username
        profileController.userToShow = self.currentUser
        
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
        viewControllers = [search, message, profile]
        Filters.sharedInstance.locationManager.stopUpdatingLocation()
    }
    
    var freshLoad: Bool = true
    
    func fetchUserData(){
        
        group.enter()
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            let ref = FIRDatabase.database().reference().child("users").child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                print("Fetch user called")
                let user = User()
            
                user.id = uid
                
                print(snapshot)
                if let dict = snapshot.value as? [String: AnyObject] {
                    user.name = dict["name"] as! String?
                    user.profileImageURL = dict["profileImg"] as! String?
                    user.caption = dict["caption"] as! String?
                    user.username = dict["username"] as! String?
                    user.activities = dict["activities"] as! [String: Int]?
                
                    if let activities = user.activities {
                        for (key, value) in activities {
                            self.tempTags.append(key)
                            self.tempVerified.append(value)
                        }
                        
                        user.tags = self.tempTags
                        user.verified = self.tempVerified
                        print(user.caption?.characters.count)
                    }
                    
                    let geoRef = FIRDatabase.database().reference().child("locations")
                    let geoFire = GeoFire(firebaseRef: geoRef)
                    
                    geoFire?.getLocationForKey(uid, withCallback: { (location, error) in
                        if error != nil {
                            print(error)
                        }
                        
                        if location != nil {
                            let geoCoder = CLGeocoder()
                            geoCoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) in
                                if error != nil {
                                    print(error)
                                }
                                
                                let placemark = placemarks?[0]
                                user.cityName = placemark?.locality as String?
                                user.streetName = placemark?.thoroughfare as String?
                                
                                
                                self.currentUser = user
                                // TODO: Check for group when a change occur
                                
                                if self.freshLoad {
                                    self.freshLoad = false
                                    self.group.leave()
                                } else {
                                    self.profileController.captionLabel.text = user.caption
                                    self.profileController.nameLabel.text = user.name
                                    self.profileController.view.layoutIfNeeded()
                                }
                            })
                        } else {
                            self.currentUser = user
                            // TODO: Check for group when a change occur
                            
                            if self.freshLoad {
                                self.freshLoad = false
                                self.group.leave()
                            } else {
                                self.profileController.captionLabel.text = user.caption
                                self.profileController.nameLabel.text = user.name
                                self.profileController.view.layoutIfNeeded()
                            }
                        }
                        
                    })
                
                    
                    
                }
                
            }, withCancel: nil)
            
            
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("Done loading")
            self.navigationController?.isNavigationBarHidden = true
            self.listenForMessages()
            OneSignal.promptLocation()
            self.setupTabBar()
            
        }
        
    }
    
    // MARK: - Auth state methods
    
    func listenForMessages(){
        messageController.messages.removeAll()
        messageController.messagesDictionary.removeAll()
        messageController.tableView.reloadData()
        messageController.observeUserMessages()
        
        checkNotificationsIds()
    }
    func handleLogout(){
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        self.dismiss(animated: true, completion: nil)
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

