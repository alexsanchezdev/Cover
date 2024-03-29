//
//  NewMessageHandlers.swift
//  SpontProject
//
//  Created by Alex Sanchez on 29/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import Firebase

extension NewMessageController {
    
    func searchUsersWithString(_ timer: Timer){
        if let searchString = timer.userInfo {
            
            if (searchString as! String).isEmpty {
                //self.usersTableView.isHidden = true
                self.users = []
                self.canSearchLabel.isHidden = false
                self.usersTableView.reloadData()
                print("Activated null string")
                return
            }
            
            let ref = FIRDatabase.database().reference().child("usernames-user")
            ref.queryOrderedByKey().queryStarting(atValue: (searchString as! String).lowercased()).queryEnding(atValue: (searchString as! String).lowercased() + "\u{f8ff}").observe(.childAdded, with: {(snapshot) in
                let uid = snapshot.value as! String
                self.tempUsers.removeAll()
                let refUsers = FIRDatabase.database().reference().child("users")
                refUsers.child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                    if let userDict = snapshot.value as? [String: AnyObject] {
                        let user = User()
                        
                        user.id = uid
                        user.name = userDict["name"] as? String
                        user.username = userDict["username"] as? String
                        user.profileImageURL = userDict["profileImg"] as? String
                        
                        if user.id == FIRAuth.auth()?.currentUser?.uid {
                            return
                        } else {
                            self.tempUsers.append(user)
                        }
                        
                        DispatchQueue.main.async {
                            self.users.removeAll()
                            self.users = self.tempUsers
                            self.canSearchLabel.isHidden = true
                            self.usersTableView.reloadData()
                            //self.usersTableView.isHidden = false
                        }
                        
                    }
                    
                    
                }, withCancel: nil)
            })
            
        }
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell") as! MessageUserCell
        
        let user = users[indexPath.row]
        cell.titleTextLabel.text = user.username
        cell.descriptionTextLabel.text = user.name
        
        if let profileImageURL = user.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithURLString(profileImageURL)
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerFor(user)
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //usersTableView.isHidden = true
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchUsersWithString(_:)), userInfo: searchText, repeats: false)
    }
    
    func delegateSetup(){
        usernameSearchBar.delegate = self
        usersTableView.delegate = self
        usersTableView.dataSource = self
    }
}


