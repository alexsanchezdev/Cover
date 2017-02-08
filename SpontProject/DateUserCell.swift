//
//  DateUserCell.swift
//  SpontProject
//
//  Created by Alex Sanchez on 6/1/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class DateUserCell: MessageUserCell {
    
    var message: Message? {
        didSet {
            setupInfo()
        }
    }
    
    let dateTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(r: 143, g: 142, b: 148, a: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        label.textAlignment = .right
        label.text = "23:37"
        return label
    }()
    
    let newMessageIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        view.layer.cornerRadius = 3
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(dateTextLabel)
        dateTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        dateTextLabel.centerYAnchor.constraint(equalTo: titleTextLabel.centerYAnchor).isActive = true
        dateTextLabel.widthAnchor.constraint(equalToConstant: 72).isActive = true
        dateTextLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        addSubview(newMessageIndicator)
        newMessageIndicator.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        newMessageIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newMessageIndicator.widthAnchor.constraint(equalToConstant: 6).isActive = true
        newMessageIndicator.heightAnchor.constraint(equalToConstant: 6).isActive = true
        newMessageIndicator.isHidden = true
    }
    
    private func setupInfo(){
        
        if let id = message?.chatPartnerId() {
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    self.titleTextLabel.text = dict["username"] as? String
                    
                    if let profileImageURL = dict["profileImg"] as? String {
                        self.profileImageView.loadImageUsingCacheWithURLString(profileImageURL)
                    }
                }
            }, withCancel: nil)
            
        }
        
        descriptionTextLabel.text = message?.text
        
        if let seconds = message?.timestamp?.doubleValue {
            let timestampDate = Date(timeIntervalSince1970: seconds)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateTextLabel.text = dateFormatter.string(from: timestampDate)
        }
        
    }
}
