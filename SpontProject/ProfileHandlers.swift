//
//  ProfileHandlers.swift
//  SpontProject
//
//  Created by Alex Sanchez on 12/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

extension ProfileController {
    
    func handleOptions(){
        let optionsMenu = UIAlertController(title: NSLocalizedString("MenuTitle", comment: "This is the message that will be shown on top of the alert controller"), message: nil, preferredStyle: .actionSheet)
        let editProfile = UIAlertAction(title: "Editar perfil", style: .default, handler: nil)
        let logoutAccount = UIAlertAction(title: "Cerrar sesión", style: .destructive, handler: {(action) in
            self.handleLogout()
        })
        let cancelOptions = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        optionsMenu.addAction(editProfile)
        optionsMenu.addAction(logoutAccount)
        optionsMenu.addAction(cancelOptions)
        
        present(optionsMenu, animated: true, completion: nil)
    }
    
    func handleLogout(){
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            OneSignal.idsAvailable { (userId, pushToken) in
                let userRef = FIRDatabase.database().reference().child("notifications").child(uid).child(userId!)
                userRef.removeValue()
                //let notifRef = FIRDatabase.database().reference().child("notifications-user").child(userId!)
                //notifRef.removeValue()
            }
        }
        
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        print("Succesfully logged out!")
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func sendMessage(){
        
        print("Send message called")
        self.tabBarController?.selectedIndex = 0
        let user = userToShow
        MessagesController.sharedInstance.showChatControllerFor(user)
        
    }
    
    func updateCurrentLocation(){
        let geoFireRef = FIRDatabase.database().reference().child("locations")
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            geoFire?.setLocation(locationManager.location, forKey: uid)
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    // MARK: Collection view delegate methods
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return activitiesArray.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activitiesTagCell", for: indexPath) as! TagCell
//        cell.tagName.text = activitiesArray[indexPath.row]
//        
//        if verifiedArray[indexPath.row] == 1 {
//            cell.backgroundColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 0.25)
//            cell.layer.borderColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1).cgColor
//            cell.layer.borderWidth = 1
//            cell.tagName.textColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
//        }
//    
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        sizingCell.tagName.text = activitiesArray[indexPath.row]
//        return self.sizingCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.bounces = (scrollView.contentOffset.y > 10)
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
    
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].collapsed! ? 0 : 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(collapsed: sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 10)
    }
    


    
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        // Adjust the height of the rows inside the section
        informationTable.beginUpdates()
        for i in 0 ..< sections[section].items.count {
            informationTable.reloadRows(at: [NSIndexPath.init(row: i, section: section) as IndexPath], with: .automatic)
        }
        informationTable.endUpdates()
    }
//    
//    func getSectionIndex(row: NSInteger) -> Int {
//        let indices = getHeaderIndices()
//        
//        for i in 0..<indices.count {
//            if i == indices.count - 1 || row < indices[i + 1] {
//                return i
//            }
//        }
//        
//        return -1
//    }
//    
//    func getRowIndex(row: NSInteger) -> Int {
//        var index = row
//        let indices = getHeaderIndices()
//        
//        for i in 0..<indices.count {
//            if i == indices.count - 1 || row < indices [i + 1] {
//                index -= indices[i]
//                break
//            }
//        }
//        
//        return index
//    }
//    
//    func getHeaderIndices() -> [Int] {
//        var index = 0
//        var indices: [Int] = []
//        
//        for section in sections {
//            indices.append(index)
//            index += section.items.count + 1
//        }
//        
//        return indices
//    }
//    
//    func toggleCollapse(){
//        let section = 1
//        let collapsed = sections[section].collapsed
//        
//        // Toggle collapse
//        sections[section].collapsed = !collapsed!
//        
//        let indices = getHeaderIndices()
//        
//        let start = indices[section]
//        let end = start + sections[section].items.count
//        
//        informationTable.beginUpdates()
//        for i in start ..< end + 1 {
//            
//            informationTable.reloadRows(at: [NSIndexPath.init(row: i, section: 1) as IndexPath], with: .automatic)
//        }
//        informationTable.endUpdates()
//    }
    
}






