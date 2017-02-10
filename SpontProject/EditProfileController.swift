//
//  EditProfileController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 10/2/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit

class EditProfileController: UIViewController {
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "oscar")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 48
        return imageView
    }()
    
    let changeProfilePicture: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cambiar perfil", for: .normal)
        button.setTitleColor(UIColor.rgb(r: 254, g: 40, b: 81, a: 1), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 254, g: 40, b: 81, a: 0.25), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        return button
    }()
    
    let updateLocation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Actualizar ubicación", for: .normal)
        button.backgroundColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Editar perfil"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        view.backgroundColor = UIColor.rgb(r: 250, g: 250, b: 250, a: 1)
        
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
    
        view.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 96).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        view.addSubview(changeProfilePicture)
        changeProfilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeProfilePicture.topAnchor.constraint(equalTo: profilePicture.bottomAnchor).isActive = true
        changeProfilePicture.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        changeProfilePicture.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
    
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    

}
