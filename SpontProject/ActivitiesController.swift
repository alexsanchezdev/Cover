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
    
    var activitiesArray = [String]()
    var userActivities = [String]()
    var newUserActivities = [String]()
    var userToChangeActivities = User()
    var editProfileController = EditProfileController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadListOfActivities()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(updateUserActivities))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
        tableView.tableFooterView = UIView()
        
        if let activities = userToChangeActivities.activities {
            for key in activities.keys {
                userActivities.append(key)
            }
        }
        
        newUserActivities = userActivities
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activitiesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        if let activities = userToChangeActivities.activities {
            if activities[activitiesArray[indexPath.row]] == 1 {
                print("Verified should show")
                cell.detailTextLabel?.text = "VERIFICADO"
            } else {
                print("Not verified should show")
                cell.detailTextLabel?.text = "NO VERIFICADO"
            }
        }
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.textLabel?.text =  activitiesArray[indexPath.row]
        cell.tintColor = UIColor.rgb(r: 255, g: 45, b: 85, a: 1)
        let view = UIView()
        view.backgroundColor = UIColor.rgb(r: 255, g: 45, b: 85, a: 0.1)
        cell.multipleSelectionBackgroundView = view
        if userActivities.contains(activitiesArray[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newUserActivities.append(activitiesArray[indexPath.row])
        print(newUserActivities)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let activities = userToChangeActivities.activities {
            if activities[activitiesArray[indexPath.row]] == 1 {
                showWarning(indexPath)
            } else {
                self.newUserActivities = self.newUserActivities.filter{$0 != self.activitiesArray[indexPath.row]}
            }
        }
        
        print(activitiesArray[indexPath.row])
        
    }
    
    func loadListOfActivities() {
        let pathToFile = Bundle.main.path(forResource: "activities", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            
            do {
                let activitiesString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                activitiesArray = activitiesString.components(separatedBy: "\n")
            } catch let err {
                print(err)
            }
            
        }
    }
    
    func showWarning(_ indexPath: IndexPath){
        let warning = UIAlertController(title: "Estás a punto de borrar una actividad verificada", message: "Esta acción es irreversible y no tendremos forma de restablecer su estado una vez la elimines. ¿Continuar?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Continuar", style: .destructive, handler: { alert in
            self.tableView.deselectRow(at: indexPath, animated: false)
            self.newUserActivities = self.newUserActivities.filter{$0 != self.activitiesArray[indexPath.row]}
        })
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: { alert in
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        })
        warning.addAction(ok)
        warning.addAction(cancel)
        
        present(warning, animated: true, completion: nil)
    }
    
    func updateUserActivities(){
        
        guard let uid = userToChangeActivities.id else { return }
        
        let loading = UIAlertController(title: nil, message: "Actualizando actividades...", preferredStyle: .alert)
        let done = UIAlertController(title: nil, message: "Actividades actualizadas", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        done.addAction(ok)
        
        present(loading, animated: true) { 
            var addValues = [String: Int]()
            var deleteValues = [String]()
            
            print("Activities array: \(self.activitiesArray)")
            print("New user activities: \(self.newUserActivities)")
            for activity in self.activitiesArray {
                if self.newUserActivities.contains(activity) {
                    addValues[activity] = 0
                } else {
                    deleteValues.append(activity)
                }
            }
            
            let userRef = FIRDatabase.database().reference().child("users").child(uid).child("activities")
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dict = snapshot.value as? [String: Int] {
                    for (activity, verify) in dict {
                        if addValues[activity] != verify {
                            addValues[activity] = verify
                        }
                    }
                }
                
                userRef.updateChildValues(addValues, withCompletionBlock: { (error, ref) in
                    
                    if error != nil {
                        print(error!)
                    }
                    
                    for delete in deleteValues {
                        userRef.child(delete).removeValue(completionBlock: { (error, ref) in
                            if error != nil {
                                print(error!)
                            }
                        })
                    }
                    
                    let activitiesRef = FIRDatabase.database().reference().child("activities").child(uid)
                    activitiesRef.updateChildValues(addValues, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error!)
                        }
                        
                        for delete in deleteValues {
                            activitiesRef.child(delete).removeValue(completionBlock: { (error, ref) in
                                if error != nil {
                                    print(error!)
                                }
                                
                                self.editProfileController.activitiesNumber.text = "\(self.newUserActivities.count)"
                                self.editProfileController.userToEdit.activities = addValues
                            })
                        }
                        
                        self.dismiss(animated: true, completion: {
                            self.present(done, animated: true, completion: nil)
                        })
                    })
                })
                
                
            }, withCancel: nil)
            
        }
    }

}
