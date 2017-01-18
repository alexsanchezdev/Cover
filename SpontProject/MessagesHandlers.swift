//
//  MessagesHandlers.swift
//  SpontProject
//
//  Created by Alex Sanchez on 27/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import Firebase

extension MessagesController {

    func handleNewMessage(){
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navigationController = UINavigationController(rootViewController: newMessageController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func showChatControllerFor(_ user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        chatLogController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func observeUserMessages(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.from = dict["from"] as! String?
                    message.to = dict["to"] as! String?
                    message.text = dict["text"] as! String?
                    message.timestamp = dict["timestamp"] as! NSNumber?
                    
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        
                        self.messages.sort(by: { (m1, m2) -> Bool in
                            return (m1.timestamp?.intValue)! > (m2.timestamp?.intValue)!
                        })
                    }
                    
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
   func handleReloadTable(){
        DispatchQueue.main.async {
            print("Is this called?")
            self.tableView.reloadData()
        }
    }
    
//    func observeMessages(){
//        let ref = FIRDatabase.database().reference().child("messages")
//        ref.observe(.childAdded, with: { (snapshot) in
//            if let dict = snapshot.value as? [String: AnyObject] {
//                let message = Message()
//                message.from = dict["from"] as! String?
//                message.to = dict["to"] as! String?
//                message.text = dict["text"] as! String?
//                message.timestamp = dict["timestamp"] as! NSNumber?
//                
//                if let toUser = message.to {
//                    self.messagesDictionary[toUser] = message
//                    self.messages = Array(self.messagesDictionary.values)
//                    
//                    self.messages.sort(by: { (m1, m2) -> Bool in
//                        return (m1.timestamp?.intValue)! > (m2.timestamp?.intValue)!
//                    })
//                }
//                
//                
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }, withCancel: nil)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DateUserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else { return }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                let user = User()
                
                user.id = chatPartnerId
                user.name = dict["name"] as? String
                user.username = dict["username"] as? String
                user.profileImageURL = dict["profileImageURL"] as? String
                self.showChatControllerFor(user)
            }
        }, withCancel: nil)
    }
}
