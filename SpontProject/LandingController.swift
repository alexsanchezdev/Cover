//
//  UILandingView.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class LandingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "bg_img")
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "logo_landing")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let loginRegisterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.isUserInteractionEnabled = true
        return view
        
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 199, g: 199, b: 205, a: 1)
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Iniciar sesión", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Crear cuenta", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(showRegister), for: .touchUpInside)
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightLight)
        label.text = "Encuentra profesionales altamente cualificados para tus sustituciones"
        return label
    }()
    
    func setupViews(){
        
        // Background image setup
        view.addSubview(backgroundImageView)
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        // Logo image setup
        backgroundImageView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 202).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        // Login/register view container setup
        backgroundImageView.addSubview(loginRegisterView)
        loginRegisterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loginRegisterView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loginRegisterView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        // Login/register separator setup
        loginRegisterView.addSubview(separatorView)
        separatorView.centerXAnchor.constraint(equalTo: loginRegisterView.centerXAnchor).isActive = true
        separatorView.centerYAnchor.constraint(equalTo: loginRegisterView.centerYAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.heightAnchor.constraint(equalTo: loginRegisterView.heightAnchor).isActive = true
        
        // Login button setup
        loginRegisterView.addSubview(loginButton)
        loginButton.leftAnchor.constraint(equalTo: loginRegisterView.leftAnchor).isActive = true
        loginButton.rightAnchor.constraint(equalTo: separatorView.leftAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: loginRegisterView.topAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: loginRegisterView.bottomAnchor).isActive = true
        
        // Register button setup
        loginRegisterView.addSubview(registerButton)
        registerButton.leftAnchor.constraint(equalTo: separatorView.rightAnchor).isActive = true
        registerButton.rightAnchor.constraint(equalTo: loginRegisterView.rightAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: loginRegisterView.topAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: loginRegisterView.bottomAnchor).isActive = true
        
        // Description label setup
        backgroundImageView.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: loginRegisterView.topAnchor, constant: -36).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 5/6).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
    }
}
