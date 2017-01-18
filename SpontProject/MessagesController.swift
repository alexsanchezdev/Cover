//
//  MessagesController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class MessagesController: UITableViewController {
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var timer: Timer?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        
        navigationItem.title = "Mensajes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        tableView.register(DateUserCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tabBarController?.tabBar.items?[0].badgeValue = ""
    }

}
