//
//  SearchHandlers.swift
//  SpontProject
//
//  Created by Alex Sanchez on 12/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

extension SearchController {
    
    // MARK: - Table view delegates methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logoCell", for: indexPath) as! LogoCell
        cell.imageView?.image = nil
        
        if shouldShowSearchResults {
            cell.nameTextLabel.text = filteredArray[indexPath.row]
            //cell.logoImageView.image = UIImage(named: filteredArray[indexPath.row])
            
        }
        else {
            cell.nameTextLabel.text = dataArray[indexPath.row]
            //cell.logoImageView.image = UIImage(named: dataArray[indexPath.row])
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultsController = ResultsController()
        if shouldShowSearchResults {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    promptOpenSettings()
                case .authorizedAlways, .authorizedWhenInUse:
                    resultsController.searchTerm = filteredArray[indexPath.row]
                    resultsController.navigationItem.title = filteredArray[indexPath.row]
                }
            } else {
                promptLocationServices()
            }
            
        }
        else {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    promptOpenSettings()
                case .authorizedAlways, .authorizedWhenInUse:
                    resultsController.searchTerm = dataArray[indexPath.row]
                    resultsController.navigationItem.title = dataArray[indexPath.row]
                }
            } else {
                promptLocationServices()
            }
        }
        
        navigationController?.pushViewController(resultsController, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    // MARK: - Search bar delegates methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        activitiesTableView.isHidden = false
        searchBar.showsCancelButton = true
        activitiesTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        activitiesTableView.isHidden = true
        searchBar.showsCancelButton = false
        activitiesTableView.reloadData()
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        shouldShowSearchResults = true
        filteredArray = dataArray.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if searchText != "" {
            shouldShowSearchResults = true
        } else {
            shouldShowSearchResults = false
        }
        
        self.activitiesTableView.reloadData()
    }
    
    // MARK: - Collection view delegates methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topActivityCell", for: indexPath) as! TopCell
        cell.activityTitle.text = topSearchArray[indexPath.row]
        cell.activityImageView.image = UIImage(named: "\(topSearchArray[indexPath.row])_icon")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                promptOpenSettings()
            case .authorizedAlways, .authorizedWhenInUse:
                let resultsController = ResultsController()
                resultsController.searchTerm = topSearchArray[indexPath.row]
                resultsController.navigationItem.title = topSearchArray[indexPath.row]
                navigationController?.pushViewController(resultsController, animated: true)
            }
        } else {
            promptLocationServices()
        }
        
    }
    
    // MARK: - Filtered list array methods
    func loadListOfActivities() {
        let pathToFile = Bundle.main.path(forResource: "activities", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            
            do {
                let activitiesString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                dataArray = activitiesString.components(separatedBy: "\n")
            } catch let err {
                print(err)
            }

            // Reload the tableview.
            activitiesTableView.reloadData()
        }
    }
    
    // MARK: - Keyboard state detector methods
    func keyboardWillShow(notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        activitiesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 48, right: 0)
        activitiesTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 48, right: 0)
    }
    
    func keyboardWillHide(){
        searchBar.showsCancelButton = false
        activitiesTableView.isHidden = true
    }
    
    
    // MARK: - Delegates setup
    func delegatesSetup(){
        searchBar.delegate = self
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        topSearchCollectionView.delegate = self
        topSearchCollectionView.dataSource = self
    }
    
}


