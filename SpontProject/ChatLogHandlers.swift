//
//  ChatLogHandlers.swift
//  SpontProject
//
//  Created by Alex Sanchez on 6/1/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import Firebase
import OneSignal

extension ChatLogController {

    func handleSend(){
        
        if self.inputTextField.text == nil || self.inputTextField.text == ""{
            return
        } else {
        
            let ref = FIRDatabase.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            let toUser = user?.id
            let fromUser = FIRAuth.auth()?.currentUser?.uid
            let timestamp = Int(Date().timeIntervalSince1970)
            let values = ["text": inputTextField.text!, "to": toUser!, "from": fromUser!, "timestamp": timestamp] as [String : Any]
            //childRef.updateChildValues(values)
            self.inputTextField.text = nil
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                
                let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromUser!)
                let messageId = childRef.key
                userMessagesRef.updateChildValues([messageId: 1])
                
                let recipientMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toUser!)
                recipientMessagesRef.updateChildValues([messageId: 1])
            }
            
            FIRDatabase.database().reference().child("notifications").child(toUser!).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                self.notificationIds.append(snapshot.key)
                print(self.notificationIds)
                FIRDatabase.database().reference().child("users").child(toUser!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String: AnyObject]{
                        let sender = dict["name"]
                        OneSignal.postNotification(["headings": ["en": sender], "contents": ["en": values["text"]], "include_player_ids": self.notificationIds, "data": ["sender": fromUser]])
                        self.notificationIds.removeAll()
                    }
                    
                }, withCancel: nil)
            }, withCancel: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 28
       
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        
        if let profileImage = self.user?.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithURLString(profileImage)
        }
        
        if message.from == FIRAuth.auth()?.currentUser?.uid {
            // outgoing gray
            cell.bubbleView.backgroundColor = ChatMessageCell.sendColor
            cell.profileImageView.isHidden = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true
        } else {
            // outgoing white
            cell.bubbleView.backgroundColor = ChatMessageCell.receivedColor
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 18
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let deviceSize = UIScreen.main.bounds
        let size = CGSize(width: deviceSize.width * 2/3, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        bottomTextInputConstraint?.constant = -keyboardHeight
        let item = collectionView(self.messageCollectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.messageCollectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: false)
        }, completion: { (completion) in
            //self.scrollToBottom()
        })
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        bottomTextInputConstraint?.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func observeMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userMessageRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.from = dict["from"] as! String?
                    message.text = dict["text"] as! String?
                    message.to = dict["to"] as! String?
                    message.timestamp = dict["timestamp"] as! NSNumber?
                    
                    if message.chatPartnerId() == self.user?.id {
                        self.messages.append(message)
                        
                        self.timer?.invalidate()
                        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.handleReloadCollection), userInfo: nil, repeats: false)
                        
                    }
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func handleReloadCollection(){
        DispatchQueue.main.async {
            self.messageCollectionView.reloadData()
            self.scrollToBottom()
            self.hideLoadingScreen()
        }
    }
    
    func scrollToBottom(){
        //let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        
        let item = collectionView(self.messageCollectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        
        self.messageCollectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: false)
    }
    
    func hideLoadingScreen(){
        loadingScreen.isHidden = true
    }
    
    
}
