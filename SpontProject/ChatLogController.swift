//
//  ChatLogController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 30/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var sizingCell: ChatMessageCell = ChatMessageCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 60, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
    
        setupInputsComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputMessageView.endEditing(true)
        self.view.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
    var bottomMessageConstraint: NSLayoutConstraint!
    
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
    
    func setupInputsComponents() {
    
        view.addSubview(inputMessageView)
        inputMessageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomMessageConstraint = inputMessageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomMessageConstraint.isActive = true
        inputMessageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputMessageView.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
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
    }
}
