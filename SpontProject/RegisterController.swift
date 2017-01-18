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
    
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Selecciona una imagen de perfil"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "País"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        return label
    }()
    
    lazy var countryTextField: TextField = {
        let textfield = TextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Selecciona tu país de residencia", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        textfield.addTarget(self, action: #selector(showCountryList), for: .editingChanged)
        return textfield
    }()
    
    func setupViews(){
        view.addSubview(registerScrollView)
        registerScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        registerScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        registerScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        registerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        registerScrollView.addSubview(profileImage)
        profileImage.centerXAnchor.constraint(equalTo: registerScrollView.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: registerScrollView.topAnchor, constant: 20).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 96).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        registerScrollView.addSubview(profileLabel)
        profileLabel.centerXAnchor.constraint(equalTo: registerScrollView.centerXAnchor).isActive = true
        profileLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        profileLabel.widthAnchor.constraint(equalTo: registerScrollView.widthAnchor, constant: -32).isActive = true
        profileLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        registerScrollView.addSubview(countryLabel)
        countryLabel.centerXAnchor.constraint(equalTo: registerScrollView.centerXAnchor).isActive = true
        countryLabel.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 36).isActive = true
        countryLabel.widthAnchor.constraint(equalTo: registerScrollView.widthAnchor, constant: -40).isActive = true
        countryLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        registerScrollView.addSubview(countryTextField)
        countryTextField.centerXAnchor.constraint(equalTo: registerScrollView.centerXAnchor).isActive = true
        countryTextField.topAnchor.constraint(equalTo: countryLabel.bottomAnchor).isActive = true
        countryTextField.widthAnchor.constraint(equalTo: registerScrollView.widthAnchor, constant: -40).isActive = true
        countryTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
}
