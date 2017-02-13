//
//  MessagesController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class MessagesController: UITableViewController {
    
    static let sharedInstance = MessagesController()
    private init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var timer: Timer?
    var showingView: Bool = false
    let systemSound: SystemSoundID = 1307
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        
        navigationItem.title = "Mensajes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        tableView.register(DateUserCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        self.tabBarController?.tabBar.subviews[1].isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showingView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.tableView.reloadData()
        showingView = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBarController?.tabBar.subviews[1].isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let message = messages[indexPath.row]
        
        if let chatPartnerId = message.chatPartnerId() {
            FIRDatabase.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print("Failed to delete message", error!)
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.handleReloadTable()
            })
        }
        
        
    }

}
