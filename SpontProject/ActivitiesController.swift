//
//  ActivitiesController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 13/2/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class ActivitiesController: UITableViewController {
    
    var editProfileController = EditProfileController()
    var userToEdit = User()
    var activitiesData = [String]()
    var activitiesArray = [String]()
    var newUserActivities = [String]()
    
    //var sortedDict = [(key: String, value: Int)]()
    //var dict = ["BODYCOMBAT": 0, "BODYJAM": 0]
    var selected = [Bool]()
    var activitiesDictionary = [String: Int]()
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadListOfActivities()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Actualizar", style: .plain, target: self, action: #selector(updateUserActivities))
        
        tableView.register(LogoCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        if let activities = userToEdit.activities {
            let sortedDict = activities.sorted(by: { $0.0 < $1.0 })
            
            for (key, value) in sortedDict {
                activitiesDictionary[key] = value
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activitiesData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LogoCell
        cell.nameTextLabel.text = activitiesData[indexPath.row]
        
        
        if activitiesDictionary[activitiesData[indexPath.row]] == nil {
            
            cell.leftPadding?.constant = -50
        } else if activitiesDictionary[activitiesData[indexPath.row]] == 0 {
            cell.leftPadding?.constant = 0
        } else if activitiesDictionary[activitiesData[indexPath.row]] == 1 {
            cell.leftPadding?.constant = 0
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! LogoCell
        
        if activitiesDictionary[activitiesData[indexPath.row]] == 0 {
            activitiesDictionary.removeValue(forKey: activitiesData[indexPath.row])
            cell.leftPadding?.constant = -50

            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
        } else if activitiesDictionary[activitiesData[indexPath.row]] == nil {
            activitiesDictionary[activitiesData[indexPath.row]] = 0
            cell.leftPadding?.constant = 0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else if activitiesDictionary[activitiesData[indexPath.row]] == 1 {
            showWarning()
        }
        
        print(activitiesDictionary)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func loadListOfActivities() {
        let pathToFile = Bundle.main.path(forResource: "activities", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            
            do {
                let activitiesString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                activitiesData = activitiesString.components(separatedBy: "\n")
            } catch let err {
                print(err)
            }
            
        }
    }
    
    func updateUserActivities(){
        guard let uid = userToEdit.id else { return }
        self.editProfileController.activitiesNumber.text = "\(self.activitiesDictionary.count)"
        
        let loading = UIAlertController(title: nil, message: "Actualizando actividades...", preferredStyle: .alert)
        let done = UIAlertController(title: nil, message: "Actividades actualizadas", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        done.addAction(ok)
        
        var valuesToRemove = [String]()
        for key in activitiesData {
            if activitiesDictionary[key] == nil {
                valuesToRemove.append(key)
            }
        }
        
        present(loading, animated: true) {
            let userRef = FIRDatabase.database().reference().child("users").child(uid).child("activities")
            self.group.enter()
            userRef.updateChildValues(self.activitiesDictionary) { (error, ref) in
                if error != nil {
                    print(error!)
                }
                
                for value in valuesToRemove {
                    userRef.child(value).removeValue()
                }
                
                let activitiesRef = FIRDatabase.database().reference().child("activities").child(uid)
                self.group.enter()
                activitiesRef.updateChildValues(self.activitiesDictionary, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                    }
                    
                    for value in valuesToRemove {
                        activitiesRef.child(value).removeValue()
                    }
                    
                    self.group.leave()
                })
                
                self.group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.dismiss(animated: true, completion: {
                self.present(done, animated: true, completion: nil)
            })
        }
    }
    
    func showWarning(){
        let warning = UIAlertController(title: "Actividad verificada", message: "Las actividades verificadas no pueden ser eliminadas.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        warning.addAction(ok)
        
        present(warning, animated: true, completion: nil)
    }
}



