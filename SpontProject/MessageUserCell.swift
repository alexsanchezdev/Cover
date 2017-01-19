//
//  MessageUserCell.swift
//  SpontProject
//
//  Created by Alex Sanchez on 6/1/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit

class MessageUserCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "user")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 22
        return iv
    }()
    
    let descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(r: 143, g: 142, b: 148, a: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        return label
    }()
    
    let titleTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        return label
    }()
    
    let newMessageIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addSubview(titleTextLabel)
        titleTextLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        titleTextLabel.bottomAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -2).isActive = true
        titleTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        titleTextLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        addSubview(descriptionTextLabel)
        descriptionTextLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        descriptionTextLabel.topAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 2).isActive = true
        descriptionTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        descriptionTextLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        addSubview(newMessageIndicator)
        newMessageIndicator.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        newMessageIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newMessageIndicator.widthAnchor.constraint(equalToConstant: 6).isActive = true
        newMessageIndicator.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
