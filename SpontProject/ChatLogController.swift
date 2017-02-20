//
//  ChatLogController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 30/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        messageCollectionView.delegate = self
        messageCollectionView.dataSource = self
        inputTextView.delegate = self
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
        removeObserversForMessage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateReadStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    var tempMessages = [Message]()
    var numberOfMessagesLoaded = 0
    let MORE_MESSAGE_INCREMENT = 100
    var oldOffset: CGFloat?
    var isSend = false
    var shouldVibrate = false
    
    var user: User? {
        didSet {
            navigationItem.title = user?.username
            observeMessages(forLast: 100)
        }
    }
    
    var bottomTextInputConstraint: NSLayoutConstraint?
    var bottomMessageCollectionConstraint: NSLayoutConstraint?
    var timer: Timer?
    var notificationIds = [String]()
    var firstTime = true
    var observerHandle: UInt = 0
    
    
    let inputMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 250, g: 250, b: 250, a: 1)
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("Send", for: .normal)
        button.setImage(UIImage(named: "send"), for: .normal)
        button.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
//    lazy var inputTextField: UITextField = {
//        let textfield = UITextField()
//        textfield.translatesAutoresizingMaskIntoConstraints = false
//        textfield.placeholder = "Enter message..."
//        textfield.addTarget(self, action: #selector(textfieldDidChange), for: .editingChanged)
//        return textfield
//    }()
    
    lazy var inputTextView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.isScrollEnabled = false
        textview.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
        textview.textContainerInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.backgroundColor = UIColor.white
        textview.layer.borderWidth = 1
        textview.layer.borderColor = UIColor.rgb(r: 220, g: 220, b: 220, a: 1).cgColor
        textview.layer.cornerRadius = 16
        return textview
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
        collection.backgroundColor = UIColor.clear
        collection.alwaysBounceVertical = true
        collection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isHidden = true
        
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
        indicator.startAnimating()
        return indicator
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "chatlog_background")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    func setupInputsComponents() {
        
        view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 36).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addSubview(inputMessageView)
        inputMessageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomTextInputConstraint = inputMessageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomTextInputConstraint?.isActive = true
        inputMessageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(messageCollectionView)
        messageCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messageCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        messageCollectionView.bottomAnchor.constraint(equalTo: inputMessageView.topAnchor).isActive = true
        
        inputMessageView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: inputMessageView.rightAnchor, constant: -16).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: inputMessageView.bottomAnchor, constant: -12).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        inputMessageView.addSubview(inputTextView)
        inputTextView.leftAnchor.constraint(equalTo: inputMessageView.leftAnchor, constant: 16).isActive = true
        inputTextView.bottomAnchor.constraint(equalTo: inputMessageView.bottomAnchor, constant: -6).isActive = true
        inputTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -16).isActive = true
        inputMessageView.topAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -6).isActive = true
        
        inputMessageView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: inputMessageView.topAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: inputMessageView.centerXAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: inputMessageView.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    var handle: UInt = 0
    var forLast: UInt = 0
    
    func updateReadStatus(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        print("Update read is called")
        if let toUser = user?.id {
            let ref = FIRDatabase.database().reference().child("user-messages").child(uid).child(toUser).queryLimited(toLast: 100)
            handle = ref.observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
                messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String:AnyObject] {
                        let to = dict["to"] as? String
                        if to == uid {
                            messagesRef.updateChildValues(["read": true])
                        }
                    }
                })
                
            }, withCancel: nil)
        }
    }
    
    func removeObserversForMessage(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        if let toUser = user?.id {
            let ref = FIRDatabase.database().reference().child("user-messages").child(uid).child(toUser)
            ref.removeObserver(withHandle: handle)
            ref.removeObserver(withHandle: observerHandle)
        }
        
        
    }
    
}
