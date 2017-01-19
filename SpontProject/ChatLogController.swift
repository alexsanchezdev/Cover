//
//  ChatLogController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 30/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class ChatLogController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        messageCollectionView.delegate = self
        messageCollectionView.dataSource = self
        activityIndicator.startAnimating()
        //navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .plain, target: nil, action: nil)
        setupInputsComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(goBack))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputMessageView.endEditing(true)
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.inputMessageView.endEditing(true)
        self.view.endEditing(true)
    }
    
    var messages = [Message]()
    
    var user: User? {
        didSet {
            navigationItem.title = user?.username
            observeMessages()
        }
    }
    
    var bottomTextInputConstraint: NSLayoutConstraint?
    var bottomMessageCollectionConstraint: NSLayoutConstraint?
    var timer: Timer?
    var notificationIds = [String]()
    
    
    let inputMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let inputTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Enter message..."
        return textfield
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 220, g: 220, b: 220, a: 1)
        return view
    }()
    
    lazy var messageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")
        collection.backgroundColor = UIColor.white
        collection.alwaysBounceVertical = true
        collection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    let loadingScreen: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    func setupInputsComponents() {
        
        view.addSubview(inputMessageView)
        inputMessageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomTextInputConstraint = inputMessageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomTextInputConstraint?.isActive = true
        inputMessageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputMessageView.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
        view.addSubview(messageCollectionView)
        messageCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messageCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        messageCollectionView.bottomAnchor.constraint(equalTo: inputMessageView.topAnchor).isActive = true
        
        inputMessageView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: inputMessageView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputMessageView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: inputMessageView.heightAnchor).isActive = true
        
        inputMessageView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: inputMessageView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: inputMessageView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: inputMessageView.heightAnchor).isActive = true
        
        inputMessageView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: inputMessageView.topAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: inputMessageView.centerXAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: inputMessageView.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(loadingScreen)
        loadingScreen.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingScreen.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingScreen.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingScreen.bottomAnchor.constraint(equalTo: separatorView.topAnchor).isActive = true
        
        loadingScreen.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: loadingScreen.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loadingScreen.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 36).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
}
