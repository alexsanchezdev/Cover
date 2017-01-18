//
//  NewMessageController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 27/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class NewMessageController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        view.backgroundColor = UIColor.blue
        
        delegateSetup()
        setupViews()
        usersTableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    var users = [User]()
    var tempUsers = [User]()
    var timer = Timer()
    var messagesController: MessagesController?
    
    let usersTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(MessageUserCell.self, forCellReuseIdentifier: "usersCell")
        return tableview
    }()
    
    lazy var usernameSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Buscar..."
        search.autocapitalizationType = .none
        search.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        search.searchBarStyle = .minimal
        search.keyboardAppearance = .dark
        return search
    }()
    
    func setupViews(){
        view.backgroundColor = UIColor.white
        
        view.addSubview(usernameSearchBar)
        usernameSearchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        usernameSearchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameSearchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        usernameSearchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(usersTableView)
        usersTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        usersTableView.topAnchor.constraint(equalTo: usernameSearchBar.bottomAnchor).isActive = true
        usersTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
