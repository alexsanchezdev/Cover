//
//  ResultsController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 23/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class ResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users = [User]()
    var usersDictionary = [String: User]()
    var timer: Timer?
    var tempTags = [String]()
    var tempVerified = [Int]()
    var searchTerm: String?
    
    lazy var resultsTableView: UITableView = {
        let table = UITableView()
        table.register(UserCell.self, forCellReuseIdentifier: "userCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.white
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        resultsTableView.tableFooterView = UIView()
    
        setupViews()
        
        retrieveUsersAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = searchTerm
    }
    
    func setupViews(){
        view.addSubview(resultsTableView)
        resultsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultsTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        resultsTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        resultsTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets.zero
        
        let user = users[indexPath.row]
        cell.nameTextLabel.text = user.name
        cell.usernameTextLabel.text = "@\(user.username!)"
        cell.locationTextLabel.text = String(format: "%.0f km", user.distance!)
        cell.tags = user.tags!
        cell.verified = user.verified!
        
        if let profileImageURL = user.profileImageURL {
            print(profileImageURL)
            cell.profileImageView.loadImageUsingCacheWithURLString(profileImageURL)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let profileController = ProfileController()
        profileController.hidesBottomBarWhenPushed = true
        profileController.navigationItem.title = user.username
        profileController.userToShow = user
        tableView.deselectRow(at: indexPath, animated: true)
        navigationItem.title = nil
        navigationController?.pushViewController(profileController, animated: true)
    }
    
    func retrieveUsersAround(){
        let geoFireRef = FIRDatabase.database().reference().child("locations")
        let geoFire = GeoFire(firebaseRef: geoFireRef)
    

        let center = Filters.sharedInstance.locationManager.location
        let circleQuery = geoFire?.query(at: center, withRadius: 5000.00)
        
        circleQuery?.observe(.keyEntered, with: { (key, location) in
            
            let activitiesRef = FIRDatabase.database().reference().child("activities").child(key!)
            activitiesRef.observe(.childAdded, with: { (snapshot) in
                if self.searchTerm == snapshot.key {
                    
                    let ref = FIRDatabase.database().reference().child("users")
                    ref.queryOrderedByKey().queryEqual(toValue: key).observe(.childAdded, with: { (snapshot) in
                        
                        let user = User()
                        
                        if snapshot.key == FIRAuth.auth()?.currentUser?.uid {
                            return
                        } else {
                            user.id = snapshot.key as String?
                        }
                        if let dict = snapshot.value as? [String: AnyObject] {
                            self.tempVerified.removeAll()
                            self.tempTags.removeAll()
                            
                            
                            user.username = dict["username"] as! String?
                            user.name = dict["name"] as! String?
                            user.caption = dict["caption"] as! String?
                            user.profileImageURL = dict["profileImg"] as! String?
                            let activities = dict["activities"] as! [String: Int]
                            
                            for (keys, values) in activities {
                                if keys == self.searchTerm {
                                    self.tempTags.insert(keys, at: 0)
                                    self.tempVerified.insert(values, at: 0)
                                } else {
                                    self.tempTags.append(keys)
                                    self.tempVerified.append(values)
                                }
                            }
                            
                            user.tags = self.tempTags
                            user.verified = self.tempVerified
                            
                            if let distance = location?.distance(from: Filters.sharedInstance.locationManager.location!) {
                                var distanceToKms = distance / 1000
                                if distanceToKms < 1 {
                                    distanceToKms = 1
                                }
                                user.distance = distanceToKms
                            }
                            
                            geoFire?.getLocationForKey(user.id, withCallback: { (location, error) in
                                if error != nil {
                                    print(error)
                                }
                                
                                let geoCoder = CLGeocoder()
                                geoCoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) in
                                    if error != nil {
                                        print(error)
                                    }
                                    
                                    let placemark = placemarks?[0]
                                    user.cityName = placemark?.addressDictionary?["City"] as! String?
                                    
                                })
                            })
                            
                            self.usersDictionary[user.username!] = user
                            
                            self.timer?.invalidate()
                            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                            
                        }
                    }, withCancel: nil)
                }
            }, withCancel: nil)
            
            
        })
        
    }
    
    func handleReloadTable(){
        DispatchQueue.main.async {
            print("Reload result table")
            self.users = Array(self.usersDictionary.values)
            self.users.sort(by: { (m1, m2) -> Bool in
                return (Int(m1.distance!)) < (Int(m2.distance!))
                //return (m1.distance.intValue)! > (m2.distance.intValue)!
            })
            self.resultsTableView.reloadData()
        }
    }
    
}
