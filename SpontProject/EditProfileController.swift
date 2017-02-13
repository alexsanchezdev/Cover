//
//  EditProfileController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 10/2/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit

class EditProfileController: UIViewController {
    
    lazy var profileScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.white
        scroll.isScrollEnabled = true
        scroll.bounces = true
        scroll.backgroundColor = UIColor.rgb(r: 250, g: 250, b: 250, a: 1)
        return scroll
    }()
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "user")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 48
        return imageView
    }()
    
    let changeProfilePicture: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cambiar foto de perfil", for: .normal)
        button.setTitleColor(UIColor.rgb(r: 254, g: 40, b: 81, a: 1), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 254, g: 40, b: 81, a: 0.25), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        return button
    }()
    
    let personalInformation: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "Alex Sanchez"
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    let separatorName: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1)
        return view
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "alxsnchez"
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    let separatorUsername: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1)
        return view
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Esto es una prueba para ver que tal se muestra. esjoiejriojse m ioueyfs weiuohfsjd ywuiehfs uyewhf usdy whiod oseh skuwi qiuyer ajhdfbnk ajhsdifwer"
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        tv.textContainerInset = UIEdgeInsets(top: 14, left: -6, bottom: 14, right: 8)
        return tv
    }()
    
    let searchTermsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TÉRMINOS DE BÚSQUEDA"
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let searchInformation: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activitiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Actividades"
        label.backgroundColor = UIColor.white
        return label
    }()
    
    var userToEdit = User()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Editar perfil"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        view.backgroundColor = UIColor.rgb(r: 250, g: 250, b: 250, a: 1)
        
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileScrollView.resizeContentSize()
    }
    
    func setupViews(){
        
//        view.addSubview(profileScrollView)
//        profileScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        profileScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        profileScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        profileScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        profileScrollView.showsVerticalScrollIndicator = false
//        profileScrollView.showsHorizontalScrollIndicator = false
    
        view.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 96).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        if let profile = userToEdit.profileImageURL {
            profilePicture.loadImageUsingCacheWithURLString(profile)
        }
        
        
        view.addSubview(changeProfilePicture)
        changeProfilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeProfilePicture.topAnchor.constraint(equalTo: profilePicture.bottomAnchor).isActive = true
        changeProfilePicture.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        changeProfilePicture.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(personalInformation)
        personalInformation.topAnchor.constraint(equalTo: changeProfilePicture.bottomAnchor).isActive = true
        personalInformation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        personalInformation.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 2).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: personalInformation.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 64).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        nameTextField.text = userToEdit.name
        
        view.addSubview(separatorName)
        separatorName.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -1).isActive = true
        separatorName.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        separatorName.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        separatorName.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
        view.addSubview(usernameTextField)
        usernameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        usernameTextField.text = userToEdit.username
        
        view.addSubview(separatorUsername)
        separatorUsername.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: -1).isActive = true
        separatorUsername.leftAnchor.constraint(equalTo: usernameTextField.leftAnchor).isActive = true
        separatorUsername.rightAnchor.constraint(equalTo: usernameTextField.rightAnchor).isActive = true
        separatorUsername.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(captionTextView)
        captionTextView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        captionTextView.leftAnchor.constraint(equalTo: usernameTextField.leftAnchor).isActive = true
        captionTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        personalInformation.bottomAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 1).isActive = true
        captionTextView.text = userToEdit.caption
        
        view.addSubview(searchTermsLabel)
        searchTermsLabel.topAnchor.constraint(equalTo: personalInformation.bottomAnchor, constant: 24).isActive = true
        searchTermsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        searchTermsLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchTermsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(searchInformation)
        searchInformation.topAnchor.constraint(equalTo: searchTermsLabel.bottomAnchor, constant: 8).isActive = true
        searchInformation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchInformation.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 2).isActive = true
        searchInformation.heightAnchor.constraint(equalToConstant: 97).isActive = true
        
        view.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: searchInformation.topAnchor).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 64).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        locationLabel.text = userToEdit.cityName
        
        view.addSubview(activitiesLabel)
        activitiesLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor).isActive = true
        activitiesLabel.leftAnchor.constraint(equalTo: locationLabel.leftAnchor).isActive = true
        activitiesLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        activitiesLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    

}
