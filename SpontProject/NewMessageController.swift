//
//  NewMessageController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 27/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

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
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        FIRDatabase.database().reference().child("names-user").removeAllObservers()
        FIRDatabase.database().reference().child("usernames-user").removeAllObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    var users = [User]()
    var tempUsers = [User]()
    var timer = Timer()
    var messagesController: MessagesController?
    let group = DispatchGroup()
    
    let usersTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(MessageUserCell.self, forCellReuseIdentifier: "usersCell")
        return tableview
    }()
    
    lazy var usernameSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = NSLocalizedString("Search...", comment: "")
        search.autocapitalizationType = .none
        search.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        search.searchBarStyle = .minimal
        return search
    }()
    
    let canSearchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("CanSearch", comment: "")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
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
        
        view.addSubview(canSearchLabel)
        canSearchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        canSearchLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        canSearchLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height

        usersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    func keyboardWillHide(notification: NSNotification){
        usersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
