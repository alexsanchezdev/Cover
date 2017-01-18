//
//  ProfileHandlers.swift
//  SpontProject
//
//  Created by Alex Sanchez on 12/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

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
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        print("Succesfully logged out!")
        let landingController = LandingController()
        present(landingController, animated: true, completion: nil)
    }
    
    // MARK: Collection view delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activitiesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activitiesTagCell", for: indexPath) as! TagCell
        cell.tagName.text = activitiesArray[indexPath.row]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizingCell.tagName.text = activitiesArray[indexPath.row]
        return self.sizingCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 10)
    }
    
}
