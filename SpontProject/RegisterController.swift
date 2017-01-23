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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        view.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        navigationItem.title = "Registro"
        
        let closeImg = UIImage(named: "close_img")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeImg, style: .plain, target: self, action: #selector(closeRegister))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        resizeToFitViews(scrollview: registerScrollView)
        
        let temp = registerScrollView.contentSize
        registerScrollView.contentSize = CGSize(width: temp.width, height: temp.height - 52)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: .UIKeyboardWillHide, object: nil)
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
    
    
    let accountTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DATOS CUENTA"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    
    let usernameTextField: RegisterTextField = {
        let textfield = RegisterTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Usuario", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        textfield.autocapitalizationType = .none
        textfield.textColor = UIColor.darkGray
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
    
    let passwordTextField: RegisterTextField = {
        let textfield = RegisterTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Contraseña", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        textfield.isSecureTextEntry = true
        textfield.textColor = UIColor.darkGray
        return textfield
    }()
    
    let passwordIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "password_icon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        iv.tintColor = UIColor.lightGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let personalTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DATOS PERSONALES"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let nameTextField: RegisterTextField = {
        let textfield = RegisterTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Nombre completo", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        textfield.keyboardType = .alphabet
        textfield.autocapitalizationType = .words
        textfield.textColor = UIColor.darkGray
        return textfield
    }()
    
    let nameIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "name_icon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        iv.tintColor = UIColor.lightGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let emailTextField: RegisterTextField = {
        let textfield = RegisterTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Correo electrónico", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        textfield.keyboardType = .emailAddress
        textfield.textColor = UIColor.darkGray
        textfield.autocapitalizationType = .none
        return textfield
    }()
    
    let emailIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "email_icon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        iv.tintColor = UIColor.lightGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let phoneTextField: RegisterTextField = {
        let textfield = RegisterTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Teléfono móvil", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        textfield.keyboardType = .numberPad
        textfield.textColor = UIColor.darkGray
        return textfield
    }()
    
    let phoneIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "phone_icon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        iv.tintColor = UIColor.lightGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Aceptar y crear cuenta", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    func setupViews(){
        
        view.addSubview(registerScrollView)
        registerScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        registerScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        registerScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        registerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -52).isActive = true
        
        view.addSubview(registerButton)
        registerButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        registerButtonBottomConstraint = registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        registerButtonBottomConstraint?.isActive = true
        registerButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        registerScrollView.addSubview(accountTitle)
        accountTitle.topAnchor.constraint(equalTo: registerScrollView.topAnchor, constant: 20).isActive = true
        accountTitle.leftAnchor.constraint(equalTo: registerScrollView.leftAnchor, constant: 20).isActive = true
        accountTitle.rightAnchor.constraint(equalTo: registerScrollView.rightAnchor, constant: -20).isActive = true
        accountTitle.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        registerScrollView.addSubview(profileImage)
        profileImage.leftAnchor.constraint(equalTo: registerScrollView.leftAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: accountTitle.bottomAnchor, constant: 20).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 96).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        registerScrollView.addSubview(usernameTextField)
        usernameTextField.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        usernameTextField.bottomAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: -8).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        usernameTextField.addSubview(usernameIcon)
        usernameIcon.leftAnchor.constraint(equalTo: usernameTextField.leftAnchor, constant: 4).isActive = true
        usernameIcon.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor, constant: -1).isActive = true
        usernameIcon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        usernameIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        registerScrollView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: usernameTextField.leftAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: usernameTextField.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        passwordTextField.addSubview(passwordIcon)
        passwordIcon.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: 6).isActive = true
        passwordIcon.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: -2).isActive = true
        passwordIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        passwordIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        registerScrollView.addSubview(personalTitle)
        personalTitle.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 36).isActive = true
        personalTitle.leftAnchor.constraint(equalTo: registerScrollView.leftAnchor, constant: 20).isActive = true
        personalTitle.rightAnchor.constraint(equalTo: registerScrollView.rightAnchor, constant: -20).isActive = true
        personalTitle.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        registerScrollView.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: personalTitle.bottomAnchor, constant: 16).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: registerScrollView.leftAnchor, constant: 20).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        nameTextField.addSubview(nameIcon)
        nameIcon.leftAnchor.constraint(equalTo: nameTextField.leftAnchor, constant: 6).isActive = true
        nameIcon.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor).isActive = true
        nameIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        nameIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        registerScrollView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        emailTextField.addSubview(emailIcon)
        emailIcon.leftAnchor.constraint(equalTo: emailTextField.leftAnchor, constant: 6).isActive = true
        emailIcon.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor).isActive = true
        emailIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        emailIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        registerScrollView.addSubview(phoneTextField)
        phoneTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        phoneTextField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        phoneTextField.addSubview(phoneIcon)
        phoneIcon.leftAnchor.constraint(equalTo: phoneTextField.leftAnchor, constant: 6).isActive = true
        phoneIcon.centerYAnchor.constraint(equalTo: phoneTextField.centerYAnchor).isActive = true
        phoneIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        phoneIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    func adjustForKeyboard(notification: NSNotification){
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            registerScrollView.contentInset = UIEdgeInsets.zero
            registerButtonBottomConstraint?.constant = 0
        } else {
            registerScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            registerButtonBottomConstraint?.constant = -keyboardViewEndFrame.height
        }
        
        registerScrollView.scrollIndicatorInsets = registerScrollView.contentInset
    
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
