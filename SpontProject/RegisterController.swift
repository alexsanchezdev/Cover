//
//  RegisterController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 26/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        view.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        navigationItem.title = "Registro"
        
        let closeImg = UIImage(named: "close_img")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeImg, style: .plain, target: self, action: #selector(closeRegister))
        
        scrollViewFit(scrollView: registerScrollView)
    }
    
    let registerScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 48
        imageView.image = UIImage(named: "user")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.rgb(r: 151, g: 151, b: 151, a: 1).cgColor
        imageView.layer.borderWidth = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        return imageView
    }()
    
    
    lazy var usernameTextField: TextFieldInsets = {
        let textfield = TextFieldInsets()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Nombre de usuario", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        return textfield
    }()
    
    let usernameIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "user_icon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        iv.tintColor = UIColor.lightGray
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    func setupViews(){
        view.addSubview(registerScrollView)
        registerScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        registerScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        registerScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        registerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        registerScrollView.addSubview(profileImage)
        profileImage.leftAnchor.constraint(equalTo: registerScrollView.leftAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: registerScrollView.topAnchor, constant: 20).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 96).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        registerScrollView.addSubview(usernameTextField)
        usernameTextField.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        usernameTextField.addSubview(usernameIcon)
        usernameIcon.leftAnchor.constraint(equalTo: usernameTextField.leftAnchor, constant: 4).isActive = true
        usernameIcon.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
        usernameIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        usernameIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
}
