//
//  RegisterController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 26/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var registerButtonBottomConstraint: NSLayoutConstraint?
    var registerScrollViewBottomConstraint: NSLayoutConstraint?
    var bottomLoginConstraint: NSLayoutConstraint?
    var directRegister: Bool = false
    let group = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        view.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        navigationItem.title = NSLocalizedString("CreateAccount", comment: "")        
        let closeImg = UIImage(named: "close_img")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeImg, style: .plain, target: self, action: #selector(dismissRegisterController))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        
        var contentRect = CGRect.zero
        for view in profileScrollView.subviews{
            contentRect = contentRect.union(view.frame)
        }
        
        profileScrollView.contentSize.width = contentRect.size.width
        profileScrollView.contentSize.height = contentRect.size.height + 74
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
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
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("AcceptCreateAccount", comment: "") , for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        tf.placeholder = NSLocalizedString("FullName", comment: "")
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
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
        tf.autocorrectionType = .no
        tf.placeholder = NSLocalizedString("Username", comment: "")
        return tf
    }()
    
    let separatorUsername: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1)
        return view
    }()
    
    let passwordImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "password_edit_icon")
        iv.contentMode = .center
        return iv
    }()
    
    let passwordTextField: EditProfileTextField = {
        let tf = EditProfileTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.placeholder = NSLocalizedString("Password", comment: "")
        tf.isSecureTextEntry = true
        return tf
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
    
    let emailTextField: EditProfileTextField = {
        let tf = EditProfileTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.placeholder = NSLocalizedString("EmailAddress", comment: "")
        return tf
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
    
    let phoneTextField: EditProfileTextField = {
        let tf = EditProfileTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.keyboardType = .phonePad
        tf.placeholder = NSLocalizedString("PhoneNumber", comment: "")
        return tf
    }()
    
    let privacyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("ByCreating", comment: "")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    
    func setupViews(){
        
        view.addSubview(profileScrollView)
        profileScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Login button setup
        view.addSubview(registerButton)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        bottomLoginConstraint = registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomLoginConstraint?.isActive = true
        
        // Activity indicator setup
        registerButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 36).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        profileScrollView.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo: profileScrollView.topAnchor, constant: 20).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 96).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
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
        
        profileScrollView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: separatorUsername.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: separatorUsername.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        profileScrollView.addSubview(passwordImageView)
        passwordImageView.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: -2).isActive = true
        passwordImageView.rightAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: -16).isActive = true
        passwordImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        passwordImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        personalInformation.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 1).isActive = true
        
        profileScrollView.addSubview(privateInfoLabel)
        privateInfoLabel.topAnchor.constraint(equalTo: personalInformation.bottomAnchor, constant: 24).isActive = true
        privateInfoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        privateInfoLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        privateInfoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        profileScrollView.addSubview(privateInformation)
        privateInformation.topAnchor.constraint(equalTo: privateInfoLabel.bottomAnchor, constant: 8).isActive = true
        privateInformation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        privateInformation.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 2).isActive = true
        privateInformation.heightAnchor.constraint(equalToConstant: 98).isActive = true
        
        profileScrollView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: privateInformation.topAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        profileScrollView.addSubview(emailImageView)
        emailImageView.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor).isActive = true
        emailImageView.rightAnchor.constraint(equalTo: emailTextField.leftAnchor, constant: -16).isActive = true
        emailImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        emailImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        profileScrollView.addSubview(separatorEmail)
        separatorEmail.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        separatorEmail.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        separatorEmail.rightAnchor.constraint(equalTo: emailTextField.rightAnchor).isActive = true
        separatorEmail.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        profileScrollView.addSubview(phoneTextField)
        phoneTextField.topAnchor.constraint(equalTo: separatorEmail.bottomAnchor).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        phoneTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        profileScrollView.addSubview(phoneImageView)
        phoneImageView.centerYAnchor.constraint(equalTo: phoneTextField.centerYAnchor).isActive = true
        phoneImageView.rightAnchor.constraint(equalTo: phoneTextField.leftAnchor, constant: -16).isActive = true
        phoneImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        phoneImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        profileScrollView.addSubview(privacyLabel)
        privacyLabel.topAnchor.constraint(equalTo: privateInformation.bottomAnchor, constant: 20).isActive = true
        privacyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        privacyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        profileScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        bottomLoginConstraint?.constant = -keyboardHeight
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func keyboardWillHide(){
        profileScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bottomLoginConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
}
