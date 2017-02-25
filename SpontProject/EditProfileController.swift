//
//  EditProfileController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 10/2/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userToEdit = User()
    var nameDidChange = false
    var usernameDidChange = false
    var previousUsername: String?
    var captionDidChange = false
    var profileDidChange = false
    
    lazy var profileScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.white
        scroll.isScrollEnabled = true
        scroll.bounces = true
        scroll.backgroundColor = UIColor.rgb(r: 250, g: 250, b: 250, a: 1)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        return scroll
    }()
    
    lazy var profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "user")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 48
        imageView.layer.borderColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1).cgColor
        imageView.layer.borderWidth = 1
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        return imageView
    }()
    
    let changeProfilePicture: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("ChangeProfileImage", comment: ""), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 255, g: 45, b: 85, a: 1), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 255, g: 45, b: 85, a: 0.25), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        button.addTarget(self, action: #selector(handleSelectProfileImage), for: .touchUpInside)
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
    
    let nameImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "name_edit_icon")
        iv.contentMode = .center
        return iv
    }()
    
    let nameTextField: EditProfileTextField = {
        let tf = EditProfileTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        tf.placeholder = NSLocalizedString("FullName", comment: "")
        return tf
    }()
    
    let separatorName: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1)
        return view
    }()
    
    let usernameImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "username_edit_icon")
        iv.contentMode = .center
        return iv
    }()
    
    let usernameTextField: EditProfileTextField = {
        let tf = EditProfileTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        tf.placeholder = NSLocalizedString("Username", comment: "")
        return tf
    }()
    
    let separatorUsername: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1)
        return view
    }()
    
    let captionImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "caption_edit_icon")
        iv.contentMode = .center
        return iv
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
        tv.textContainerInset = UIEdgeInsets(top: 14, left: -6, bottom: 14, right: 8)
    
        return tv
    }()
    
    let searchTermsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("SearchTerms", comment: "")
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
    
    let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "location_edit_icon")
        iv.contentMode = .center
        return iv
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
    
    let activitiesImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "activities_edit_icon")
        iv.contentMode = .center
        return iv
    }()
    
    lazy var activitiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("ActivitiesEdit", comment: "")
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
    
    let privateInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("PrivateInformation", comment: "")
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let privateInformation: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let emailImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "email_edit_icon")
        iv.contentMode = .center
        return iv
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowEmailWarning)))
        return label
    }()
    
    let separatorEmail: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1)
        return view
    }()
    
    let phoneImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "phone_edit_icon")
        iv.contentMode = .center
        return iv
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowPhoneWarning)))
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("EditProfile", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(updateDatabase))
        view.backgroundColor = UIColor.rgb(r: 250, g: 250, b: 250, a: 1)
        
        captionTextView.delegate = self
        previousUsername = self.userToEdit.username
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userToEdit.caption == "" || userToEdit.caption == nil {
            captionTextView.text = NSLocalizedString("AddDescription", comment: "")
            captionTextView.textColor = UIColor.lightGray
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileScrollView.resizeContentSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileScrollView.resizeContentSize()
    }
    
    func setupViews(){
        
        view.addSubview(profileScrollView)
        profileScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
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
        changeProfilePicture.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        profileScrollView.addSubview(personalInformation)
        personalInformation.topAnchor.constraint(equalTo: changeProfilePicture.bottomAnchor).isActive = true
        personalInformation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        personalInformation.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 2).isActive = true
        
        profileScrollView.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: personalInformation.topAnchor, constant: 1).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        nameTextField.text = userToEdit.name
        
        profileScrollView.addSubview(nameImageView)
        nameImageView.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor).isActive = true
        nameImageView.rightAnchor.constraint(equalTo: nameTextField.leftAnchor, constant: -16).isActive = true
        nameImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        nameImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
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
        
        profileScrollView.addSubview(usernameImageView)
        usernameImageView.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
        usernameImageView.rightAnchor.constraint(equalTo: usernameTextField.leftAnchor, constant: -16).isActive = true
        usernameImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        usernameImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
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
        
        profileScrollView.addSubview(captionImageView)
        captionImageView.centerYAnchor.constraint(equalTo: captionTextView.centerYAnchor).isActive = true
        captionImageView.rightAnchor.constraint(equalTo: captionTextView.leftAnchor, constant: -16).isActive = true
        captionImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        captionImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
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
        if let city = userToEdit.city {
            locationLabel.text = city
            if let street = userToEdit.street {
                locationLabel.text = street + ", " + city
            }
        } else {
            locationLabel.text = NSLocalizedString("NoLocation", comment: "")
        }
        
        profileScrollView.addSubview(locationImageView)
        locationImageView.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor).isActive = true
        locationImageView.rightAnchor.constraint(equalTo: locationLabel.leftAnchor, constant: -16).isActive = true
        locationImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        locationImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
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
        
        profileScrollView.addSubview(activitiesImageView)
        activitiesImageView.centerYAnchor.constraint(equalTo: activitiesLabel.centerYAnchor).isActive = true
        activitiesImageView.rightAnchor.constraint(equalTo: activitiesLabel.leftAnchor, constant: -16).isActive = true
        activitiesImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        activitiesImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        activitiesLabel.addSubview(activitiesNumber)
        activitiesNumber.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36).isActive = true
        activitiesNumber.centerYAnchor.constraint(equalTo: activitiesLabel.centerYAnchor).isActive = true
        activitiesNumber.heightAnchor.constraint(equalToConstant: 28).isActive = true
        activitiesNumber.widthAnchor.constraint(equalToConstant: 40).isActive = true
        if let activities = userToEdit.activities {
            activitiesNumber.text = "\(activities.count)"
        }
        
        profileScrollView.addSubview(privateInfoLabel)
        privateInfoLabel.topAnchor.constraint(equalTo: searchInformation.bottomAnchor, constant: 24).isActive = true
        privateInfoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        privateInfoLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        privateInfoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        profileScrollView.addSubview(privateInformation)
        privateInformation.topAnchor.constraint(equalTo: privateInfoLabel.bottomAnchor, constant: 8).isActive = true
        privateInformation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        privateInformation.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 2).isActive = true
        privateInformation.heightAnchor.constraint(equalToConstant: 98).isActive = true
        
        profileScrollView.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: privateInformation.topAnchor).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        emailLabel.text = userToEdit.email!
        
        profileScrollView.addSubview(emailImageView)
        emailImageView.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor).isActive = true
        emailImageView.rightAnchor.constraint(equalTo: emailLabel.leftAnchor, constant: -16).isActive = true
        emailImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        emailImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        profileScrollView.addSubview(separatorEmail)
        separatorEmail.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        separatorEmail.leftAnchor.constraint(equalTo: emailLabel.leftAnchor).isActive = true
        separatorEmail.rightAnchor.constraint(equalTo: emailLabel.rightAnchor).isActive = true
        separatorEmail.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        profileScrollView.addSubview(phoneLabel)
        phoneLabel.topAnchor.constraint(equalTo: separatorEmail.bottomAnchor).isActive = true
        phoneLabel.leftAnchor.constraint(equalTo: emailLabel.leftAnchor).isActive = true
        phoneLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        phoneLabel.text = userToEdit.phone!
        
        profileScrollView.addSubview(phoneImageView)
        phoneImageView.centerYAnchor.constraint(equalTo: phoneLabel.centerYAnchor).isActive = true
        phoneImageView.rightAnchor.constraint(equalTo: phoneLabel.leftAnchor, constant: -16).isActive = true
        phoneImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        phoneImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
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
        activitiesController.userToEdit = self.userToEdit
        activitiesController.editProfileController = self
        navigationController?.pushViewController(activitiesController, animated: true)
    }

    
    func nameChanged() {
        nameDidChange = true
    }
    
    func usernameChanged(){
        usernameDidChange = true
    }
    
    func captionChanged() {
        captionDidChange = true
    }
    
    func updateDatabase(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let updateButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(updateDatabase))
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        // Show spinner and disable button until upload finish
        navigationItem.rightBarButtonItem = nil
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        spinner.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        
        let group = DispatchGroup()
        let usersRef = FIRDatabase.database().reference().child("users").child(uid)
        let usernamesRef = FIRDatabase.database().reference().child("usernames")
        let usernameUserRef = FIRDatabase.database().reference().child("usernames-user")
        
        
        
        if profileDidChange {
            group.enter()
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile-images").child("\(imageName).jpeg")
            if let uploadData = UIImageJPEGRepresentation(self.profilePicture.image!, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print (error!)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        usersRef.updateChildValues(["profileImg": profileImageURL])
                        group.leave()
                    }
                })
            }
        }
        
        if nameDidChange {
            let nameAlert = UIAlertController(title: nil, message: NSLocalizedString("NameRequired", comment: ""), preferredStyle: .alert)
            nameAlert.addAction(ok)
            group.enter()
            if let name = self.nameTextField.text {
                if name != "" {
                    usersRef.updateChildValues(["name": name])
                    FIRDatabase.database().reference().child("names-user").updateChildValues([uid: name.lowercased()])
                    group.leave()
                } else {
                    present(nameAlert, animated: true, completion: {
                        self.navigationItem.rightBarButtonItem = updateButton
                    })
                    return
                }
            } else {
                present(nameAlert, animated: true, completion: {
                    self.navigationItem.rightBarButtonItem = updateButton
                })
            }
        }
        
        if usernameDidChange {
            let itsAlreadyTakenAlert = UIAlertController(title: nil, message: NSLocalizedString("UsernameRegistered", comment: ""), preferredStyle: .alert)
            itsAlreadyTakenAlert.addAction(ok)
            
            let notValidAlert = UIAlertController(title: NSLocalizedString("UsernameNotValid", comment: ""), message: NSLocalizedString("MustContain", comment: ""), preferredStyle: .alert)
            notValidAlert.addAction(ok)
            group.enter()
            if let username = self.usernameTextField.text {
                
                let decapitalized = username.lowercased()
                
                if decapitalized == previousUsername {
                    group.leave()
                    self.navigationItem.rightBarButtonItem = updateButton
                    return
                } else {
                    usernamesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dict = snapshot.value as? [String: AnyObject] {
                            
                            if dict.keys.contains(decapitalized) {
                                self.present(itsAlreadyTakenAlert, animated: true, completion: {
                                    self.navigationItem.rightBarButtonItem = updateButton
                                })
                                
                                return
                            } else {
                                if self.isValidInput(decapitalized) {
                                    
                                    usersRef.updateChildValues(["username": decapitalized])
                                    usernamesRef.updateChildValues([decapitalized: 1])
                                    usernameUserRef.updateChildValues([decapitalized: uid])
                                    
                                    if let previous = self.previousUsername {
                                        usernamesRef.child(previous).removeValue()
                                        usernameUserRef.child(previous).removeValue()
                                        group.leave()
                                    }
                                    
                                } else {
                                    self.present(notValidAlert, animated: true, completion: {
                                        self.navigationItem.rightBarButtonItem = updateButton
                                    })
                                    return
                                }
                                
                            }
                            
                        }
                        
                    }, withCancel: nil)
                }
               

            }
        }
        
        if captionDidChange {
            group.enter()
            
            if let caption = captionTextView.text {
                if caption == NSLocalizedString("AddDescription", comment: "") {
                    usersRef.child("caption").removeValue()
                    group.leave()
                } else {
                    usersRef.updateChildValues(["caption": caption])
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { 
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("AddDescription", comment: "")
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        captionDidChange = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePicture.image = selectedImage
            profileDidChange = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func handleSelectProfileImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        
        let optionMenu = UIAlertController(title: NSLocalizedString("ChangeProfileImage", comment: ""), message: nil, preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: NSLocalizedString("ChooseFromLibrary", comment: ""), style: .default, handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        })
        let takePhoto = UIAlertAction(title: NSLocalizedString("TakePhoto", comment: ""), style: .default, handler: { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(photoLibrary)
        optionMenu.addAction(cancel)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        profileScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    func keyboardWillHide(){
        profileScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func isValidInput(_ Input:String) -> Bool {
        let RegEx = "\\A\\w{4,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
    func handleShowEmailWarning(){
        let warning = UIAlertController(title: NSLocalizedString("InvalidOperation", comment: ""), message: NSLocalizedString("CantChangeEmail", comment: ""), preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        warning.addAction(ok)
        present(warning, animated: true, completion: nil)
    }
    
    func handleShowPhoneWarning(){
        let warning = UIAlertController(title: NSLocalizedString("InvalidOperation", comment: ""), message: NSLocalizedString("CantChangePhone", comment: ""), preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        warning.addAction(ok)
        present(warning, animated: true, completion: nil)
    }
}
