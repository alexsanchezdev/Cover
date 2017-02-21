//
//  UILoginView.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextFieldsBorders()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }

    var bottomLoginConstraint: NSLayoutConstraint!
    var centerTextfieldConstraint: NSLayoutConstraint!
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "logo_login")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let errorMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 208, g: 2, b: 27, a: 1)
        view.isHidden = true
        return view
    }()
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("TryAgain", comment: "")
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let loginContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.attributedPlaceholder = NSMutableAttributedString(string: NSLocalizedString("EmailAddress", comment: ""), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        tf.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        tf.keyboardAppearance = .dark
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.clearButtonMode = .whileEditing
        tf.addTarget(self, action: #selector(resetWarning), for: .editingChanged)
        return tf
    }()
    
    lazy var passwordTextField: TextFieldInsets = {
        let tf = TextFieldInsets()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        tf.attributedPlaceholder = NSMutableAttributedString(string: NSLocalizedString("Password", comment: ""), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        tf.isSecureTextEntry = true
        tf.keyboardAppearance = .dark
        tf.addTarget(self, action: #selector(resetWarning), for: .editingChanged)
        return tf
    }()
    
    lazy var forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("ForgetPassword", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.rgb(r: 254, g: 40, b: 81, a: 1), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 254, g: 40, b: 81, a: 0.25), for: .highlighted)
        button.titleLabel?.textAlignment = .right
        button.addTarget(self, action: #selector(lostPassword), for: .touchUpInside)
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("FirstTime", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.rgb(r: 254, g: 40, b: 81, a: 1), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 254, g: 40, b: 81, a: 0.25), for: .highlighted)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    func setupViews(){
        
        // Login button setup
        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        bottomLoginConstraint = loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomLoginConstraint.isActive = true
        
        // Logo image view setup
        view.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 116).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // Error message view setup
        view.addSubview(errorMessageView)
        errorMessageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorMessageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        errorMessageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        errorMessageView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        // Error message label setup
        errorMessageView.addSubview(errorMessageLabel)
        errorMessageLabel.centerXAnchor.constraint(equalTo: errorMessageView.centerXAnchor).isActive = true
        errorMessageLabel.centerYAnchor.constraint(equalTo: errorMessageView.centerYAnchor).isActive = true
        errorMessageLabel.widthAnchor.constraint(equalTo: errorMessageView.widthAnchor).isActive = true
        errorMessageLabel.heightAnchor.constraint(equalTo: errorMessageView.heightAnchor).isActive = true
        
        // Login container view setup
        view.addSubview(loginContainerView)
        loginContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 5/6).isActive = true
        loginContainerView.heightAnchor.constraint(equalToConstant: 164).isActive = true
        
        centerTextfieldConstraint = loginContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        centerTextfieldConstraint.isActive = true
    
        // Email text field setup
        loginContainerView.addSubview(emailTextField)
        emailTextField.centerXAnchor.constraint(equalTo: loginContainerView.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: loginContainerView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // Password text field setup
        loginContainerView.addSubview(passwordTextField)
        passwordTextField.centerXAnchor.constraint(equalTo: loginContainerView.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // Forget password button setup
        passwordTextField.addSubview(forgetPasswordButton)
        forgetPasswordButton.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor).isActive = true
        forgetPasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        forgetPasswordButton.widthAnchor.constraint(equalToConstant: 128).isActive = true
        forgetPasswordButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor).isActive = true
        
        // Create account button setup
        loginContainerView.addSubview(registerButton)
        registerButton.centerXAnchor.constraint(equalTo: loginContainerView.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: loginContainerView.bottomAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        // Activity indicator setup
        loginButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 36).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupTextFieldsBorders(){
        let borderBottomEmail = CALayer()
        let borderWidthEmail = CGFloat(2.0)
        borderBottomEmail.borderColor = UIColor.rgb(r: 199, g: 199, b: 205, a: 1).cgColor
        borderBottomEmail.frame = CGRect(x: 0, y: emailTextField.frame.height - 1.0, width: emailTextField.frame.width , height: emailTextField.frame.height - 1.0)
        borderBottomEmail.borderWidth = borderWidthEmail
        emailTextField.layer.addSublayer(borderBottomEmail)
        emailTextField.layer.masksToBounds = true
        
        let borderBottomPassword = CALayer()
        let borderWidthPassword = CGFloat(2.0)
        borderBottomPassword.borderColor = UIColor.rgb(r: 199, g: 199, b: 205, a: 1).cgColor
        borderBottomPassword.frame = CGRect(x: 0, y: passwordTextField.frame.height - 1.0, width: passwordTextField.frame.width , height: passwordTextField.frame.height - 1.0)
        borderBottomPassword.borderWidth = borderWidthPassword
        passwordTextField.layer.addSublayer(borderBottomPassword)
        passwordTextField.layer.masksToBounds = true
    }
}
