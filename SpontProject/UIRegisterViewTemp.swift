//
//  RegisterView.swift
//  SpontProject
//
//  Created by Alex Sanchez on 15/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class UIRegisterViewTemp: UIViewController {
    
    // MARK - Variables
    
    var profileEmailViewX: NSLayoutConstraint!
    var profileEmailViewY: NSLayoutConstraint!
    var passwordPhoneViewX: NSLayoutConstraint!
    var passwordPhoneViewY: NSLayoutConstraint!
    var backButtonX: NSLayoutConstraint!
    
    let profileEmailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "add_profile")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 64
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
        return imageView
    }()
    let emailTextField: TextFieldLoginScreen = {
        let textfield = TextFieldLoginScreen()
        textfield.createTextFieldWith(placeholder: "Correo electrónico")
        return textfield
    }()
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("Siguiente", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white.withAlphaComponent(0.25), for: .disabled)
        
        button.addTarget(self, action: #selector(animateToLeft), for: .touchUpInside)
        return button
    }()
    let passwordPhoneView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let nameTextField: TextFieldLoginScreen = {
        let textfield = TextFieldLoginScreen()
        textfield.createTextFieldWith(placeholder: "Nombre completo")
        return textfield
    }()
    let passwordTextField: TextFieldLoginScreen = {
        let textfield = TextFieldLoginScreen()
        textfield.createTextFieldWith(placeholder: "Contraseña")
        return textfield
    }()
    let phoneTextField: TextFieldLoginScreen = {
        let textfield = TextFieldLoginScreen()
        textfield.createTextFieldWith(placeholder: "Teléfono movil")
        return textfield
    }()
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("Registrarse", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white.withAlphaComponent(0.25), for: .disabled)
        return button
    }()
    let registerAccountView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let registerAccountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "INICIAR SESIÓN"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back"), for: .normal)
        
        button.addTarget(self, action: #selector(animateToRight), for: .touchUpInside)
        
        return button
    }()
    
    // MARK - Overrides
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createGradientLayer()
        setupProfileEmailView()
        setupPasswordPhoneView()
        setupLoginAccountView()
        
        view.backgroundColor = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        textFieldDidChange()
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupProfileEmailView(){
        view.addSubview(profileEmailView)
        profileEmailViewX = profileEmailView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        profileEmailViewY = profileEmailView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -24)
        let profileEmailViewW = profileEmailView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -72)
        let profileEmailViewH = profileEmailView.heightAnchor.constraint(equalToConstant: 260)
        NSLayoutConstraint.activate([profileEmailViewX, profileEmailViewY, profileEmailViewW, profileEmailViewH])
        
        profileEmailView.addSubview(profileImageView)
        let profileImageViewX = profileImageView.centerXAnchor.constraint(equalTo: profileEmailView.centerXAnchor)
        let profileImageViewY = profileImageView.topAnchor.constraint(equalTo: profileEmailView.topAnchor)
        let profileImageViewW = profileImageView.widthAnchor.constraint(equalToConstant: 128)
        let profileImageViewH = profileImageView.heightAnchor.constraint(equalToConstant: 128)
        NSLayoutConstraint.activate([profileImageViewX, profileImageViewY, profileImageViewW, profileImageViewH])
        
        profileEmailView.addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: profileEmailView.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: profileEmailView.bottomAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: profileEmailView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        profileEmailView.addSubview(emailTextField)
        emailTextField.centerXAnchor.constraint(equalTo: profileEmailView.centerXAnchor).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -14).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: profileEmailView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    func setupPasswordPhoneView(){
        view.addSubview(passwordPhoneView)
        passwordPhoneViewX = passwordPhoneView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width)
        passwordPhoneViewY = passwordPhoneView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        let passwordPhoneViewW = passwordPhoneView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -72)
        let passwordPhoneViewH = passwordPhoneView.heightAnchor.constraint(equalToConstant: 218)
        NSLayoutConstraint.activate([passwordPhoneViewX, passwordPhoneViewY, passwordPhoneViewW, passwordPhoneViewH])
        
        passwordPhoneView.addSubview(nameTextField)
        let nameTextFieldX = nameTextField.centerXAnchor.constraint(equalTo: passwordPhoneView.centerXAnchor, constant: 0)
        let nameTextFieldY = nameTextField.topAnchor.constraint(equalTo: passwordPhoneView.topAnchor, constant: 0)
        let nameTextFieldW = nameTextField.widthAnchor.constraint(equalTo: passwordPhoneView.widthAnchor, constant: 0)
        let nameTextFieldH = nameTextField.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([nameTextFieldX, nameTextFieldY, nameTextFieldW, nameTextFieldH])
        
        passwordPhoneView.addSubview(passwordTextField)
        let passwordTextFieldX = passwordTextField.centerXAnchor.constraint(equalTo: passwordPhoneView.centerXAnchor, constant: 0)
        let passwordTextFieldY = passwordTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 14)
        let passwordTextFieldW = passwordTextField.widthAnchor.constraint(equalTo: passwordPhoneView.widthAnchor, constant: 0)
        let passwordTextFieldH = passwordTextField.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([passwordTextFieldX, passwordTextFieldY, passwordTextFieldW, passwordTextFieldH])
        
        passwordPhoneView.addSubview(phoneTextField)
        let phoneTextFieldX = phoneTextField.centerXAnchor.constraint(equalTo: passwordPhoneView.centerXAnchor, constant: 0)
        let phoneTextFieldY = phoneTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 14)
        let phoneTextFieldW = phoneTextField.widthAnchor.constraint(equalTo: passwordPhoneView.widthAnchor, constant: 0)
        let phoneTextFieldH = phoneTextField.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([phoneTextFieldX, phoneTextFieldY, phoneTextFieldW, phoneTextFieldH])
        
        passwordPhoneView.addSubview(registerButton)
        let registerButtonX = registerButton.centerXAnchor.constraint(equalTo: passwordPhoneView.centerXAnchor, constant: 0)
        let registerButtonY = registerButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 14)
        let registerButtonW = registerButton.widthAnchor.constraint(equalTo: passwordPhoneView.widthAnchor, constant: 0)
        let registerButtonH = registerButton.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([registerButtonX, registerButtonY, registerButtonW, registerButtonH])
        
        view.addSubview(backButton)
        let horizontalOffset = view.frame.width + 20
        backButtonX = backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalOffset)
        let backButtonY = backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        let backButtonW = backButton.widthAnchor.constraint(equalToConstant: 20)
        let backButtonH = backButton.heightAnchor.constraint(equalToConstant: 16)
        NSLayoutConstraint.activate([backButtonX, backButtonY, backButtonW, backButtonH])
    }
    
    func setupLoginAccountView(){
        
        view.addSubview(registerAccountView)
        registerAccountView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerAccountView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true
        registerAccountView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 2).isActive = true
        registerAccountView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        registerAccountView.addSubview(registerAccountLabel)
        registerAccountLabel.centerXAnchor.constraint(equalTo: registerAccountView.centerXAnchor).isActive = true
        registerAccountLabel.centerYAnchor.constraint(equalTo: registerAccountView.centerYAnchor).isActive = true
        registerAccountLabel.widthAnchor.constraint(equalTo: registerAccountView.widthAnchor).isActive = true
        registerAccountLabel.heightAnchor.constraint(equalTo: registerAccountView.heightAnchor).isActive = true
        
        // Handle tap on label
        
        registerAccountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissRegisterController)))
        
    }
    
    func dismissRegisterController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissLoginController(){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //    func createGradientLayer(){
    //        let gradientLayer : CAGradientLayer = CAGradientLayer()
    //        let secondColor = UIColor(red: 77/255, green: 17/255, blue: 134/255, alpha: 1)
    //        let firstColor = UIColor(red: 31/255, green: 58/255, blue: 147/255, alpha: 1)
    //        gradientLayer.frame = self.view.bounds
    //        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
    //        self.view.layer.insertSublayer(gradientLayer, at: 0)
    //    }
    
    func animateToLeft(){
        profileEmailViewX.constant = -view.frame.width
        passwordPhoneViewX.constant = 0
        backButtonX.constant = 20
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateToRight(){
        profileEmailViewX.constant = 0
        passwordPhoneViewX.constant = view.frame.width
        backButtonX.constant = view.frame.width + 20
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldDidChange(){
        if emailTextField.text == "" {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let middleScreenWithoutKeyboard = (view.frame.height / 2) - keyboardHeight
        profileEmailViewY.constant = -((view.frame.height - keyboardHeight) / 2) + middleScreenWithoutKeyboard
        passwordPhoneViewY.constant = -((view.frame.height - keyboardHeight) / 2) + middleScreenWithoutKeyboard + 24
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification){
        profileEmailViewY.constant = -24
        passwordPhoneViewY.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
