//
//  ResultsController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 23/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class ResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
        setupViews()
    }
    
    func setupViews(){
        view.addSubview(resultsTableView)
        resultsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultsTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        resultsTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        resultsTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileController = ProfileController()
        profileController.navigationItem.title = "madfit_lifestyle"
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(profileController, animated: true)
    }
    
}
