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
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "background_character")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let newMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("EmptyMessages", comment: "")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImage)
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -8).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -64).isActive = true
        backgroundImage.widthAnchor.constraint(equalToConstant: 242).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: 233).isActive = true
        
        view.addSubview(newMessageLabel)
        newMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newMessageLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 36).isActive = true
        newMessageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        navigationItem.title = NSLocalizedString("Messages", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
        
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
