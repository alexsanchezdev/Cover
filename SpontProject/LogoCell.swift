//
//  ActivityCell.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class LogoCell: UITableViewCell {
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //iv.backgroundColor = UIColor.rgb(r: 255, g: 0, b: 50, a: 1)
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "check")
        return iv
    }()
    
    let nameTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        return label
    }()
    
    var leftPadding: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorInset = UIEdgeInsets.zero
        backgroundColor = UIColor.clear
        setupViews()
    }
    
    
    func setupViews(){
        
        addSubview(logoImageView)
        leftPadding = logoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: -50)
        logoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftPadding?.isActive = true
        
        
        addSubview(nameTextLabel)
        nameTextLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 20).isActive = true
        nameTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        nameTextLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
