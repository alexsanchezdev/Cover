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
        
        FIRDatabase.database().reference().child("notifications").observe(.value, with: { (snapshot) in
            if let _ = snapshot.value as? [String: AnyObject]{
                OneSignal.postNotification(["headings": ["en": "Alex Sanchez"], "contents": ["en": values["text"]], "include_player_ids": ["61e7fb1c-3428-4048-a834-eae837dd9f53"], "data": ["sender": "owue098ruew_w09e8"]])
            }
        }, withCancel: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
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
        
        bottomMessageConstraint.constant = -keyboardHeight
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completion) in
            self.scrollToBottom(true)
        })
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        bottomMessageConstraint.constant = 0
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
                        
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                            self.scrollToBottom(true)
                        }
                    }
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func scrollToBottom(_ animated: Bool){
        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex, at: .bottom, animated: animated)
    }
}
