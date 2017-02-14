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
        button.setTitleColor(UIColor.rgb(r: 255, g: 45, b: 85, a: 1), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 255, g: 45, b: 85, a: 0.25), for: .highlighted)
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
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLocationController)))
        return label
    }()
    
    let separatorLocation: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1)
        return view
    }()
    
    lazy var activitiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Actividades"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleActivitiesController)))
        return label
    }()
    
    let activitiesNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.rgb(r: 255, g: 45, b: 80, a: 1)
        label.layer.cornerRadius = 14
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        label.text = "0"
        label.textAlignment = .center
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileScrollView.resizeContentSize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileScrollView.resizeContentSize()
    }
    
    func setupViews(){
        
        view.addSubview(profileScrollView)
        profileScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        profileScrollView.showsVerticalScrollIndicator = false
        profileScrollView.showsHorizontalScrollIndicator = false
    
        profileScrollView.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo: profileScrollView.topAnchor, constant: 20).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 96).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        if let profile = userToEdit.profileImageURL {
            profilePicture.loadImageUsingCacheWithURLString(profile)
        }
        
        
        profileScrollView.addSubview(changeProfilePicture)
        changeProfilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeProfilePicture.topAnchor.constraint(equalTo: profilePicture.bottomAnchor).isActive = true
        changeProfilePicture.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        changeProfilePicture.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        profileScrollView.addSubview(personalInformation)
        personalInformation.topAnchor.constraint(equalTo: changeProfilePicture.bottomAnchor).isActive = true
        personalInformation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        personalInformation.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 2).isActive = true
        
        profileScrollView.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: personalInformation.topAnchor, constant: 1).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 64).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        nameTextField.text = userToEdit.name
        
        profileScrollView.addSubview(separatorName)
        separatorName.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        separatorName.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        separatorName.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        separatorName.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
        profileScrollView.addSubview(usernameTextField)
        usernameTextField.topAnchor.constraint(equalTo: separatorName.bottomAnchor).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: separatorName.leftAnchor).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        usernameTextField.text = userToEdit.username
        
        profileScrollView.addSubview(separatorUsername)
        separatorUsername.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        separatorUsername.leftAnchor.constraint(equalTo: usernameTextField.leftAnchor).isActive = true
        separatorUsername.rightAnchor.constraint(equalTo: usernameTextField.rightAnchor).isActive = true
        separatorUsername.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        profileScrollView.addSubview(captionTextView)
        captionTextView.topAnchor.constraint(equalTo: separatorUsername.bottomAnchor).isActive = true
        captionTextView.leftAnchor.constraint(equalTo: separatorUsername.leftAnchor).isActive = true
        captionTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        personalInformation.bottomAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 1).isActive = true
        captionTextView.text = userToEdit.caption
        
        profileScrollView.addSubview(searchTermsLabel)
        searchTermsLabel.topAnchor.constraint(equalTo: personalInformation.bottomAnchor, constant: 24).isActive = true
        searchTermsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        searchTermsLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchTermsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        profileScrollView.addSubview(searchInformation)
        searchInformation.topAnchor.constraint(equalTo: searchTermsLabel.bottomAnchor, constant: 8).isActive = true
        searchInformation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchInformation.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 2).isActive = true
        searchInformation.heightAnchor.constraint(equalToConstant: 98).isActive = true
        
        profileScrollView.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: searchInformation.topAnchor).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 64).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        locationLabel.text = userToEdit.streetName! + ", " + userToEdit.cityName!
        
        profileScrollView.addSubview(separatorLocation)
        separatorLocation.topAnchor.constraint(equalTo: locationLabel.bottomAnchor).isActive = true
        separatorLocation.leftAnchor.constraint(equalTo: locationLabel.leftAnchor).isActive = true
        separatorLocation.rightAnchor.constraint(equalTo: locationLabel.rightAnchor).isActive = true
        separatorLocation.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        profileScrollView.addSubview(activitiesLabel)
        activitiesLabel.topAnchor.constraint(equalTo: separatorLocation.bottomAnchor).isActive = true
        activitiesLabel.leftAnchor.constraint(equalTo: locationLabel.leftAnchor).isActive = true
        activitiesLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        activitiesLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        activitiesLabel.addSubview(activitiesNumber)
        activitiesNumber.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36).isActive = true
        activitiesNumber.centerYAnchor.constraint(equalTo: activitiesLabel.centerYAnchor).isActive = true
        activitiesNumber.heightAnchor.constraint(equalToConstant: 28).isActive = true
        activitiesNumber.widthAnchor.constraint(equalToConstant: 40).isActive = true
        if let activities = userToEdit.activities {
            activitiesNumber.text = "\(activities.count)"
        }
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleLocationController(){
        let locationController = LocationController()
        locationController.editProfileController = self
        locationController.userToChangeLocation = userToEdit
        navigationController?.pushViewController(locationController, animated: true)
    }
    
    func handleActivitiesController(){
        let activitiesController = ActivitiesController()
        activitiesController.editProfileController = self
        activitiesController.userToChangeActivities = userToEdit
        navigationController?.pushViewController(activitiesController, animated: true)
    }

    

}
