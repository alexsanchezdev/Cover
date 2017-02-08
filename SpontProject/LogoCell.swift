//
//  ActivityCell.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class LogoCell: UITableViewCell {
    
//    let logoImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        //iv.backgroundColor = UIColor.rgb(r: 255, g: 0, b: 50, a: 1)
//        iv.contentMode = UIViewContentMode.right
//        return iv
//    }()
    
    let nameTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorInset = UIEdgeInsets.zero
        backgroundColor = UIColor.clear
        setupViews()
    }
    
    
    func setupViews(){
        
        addSubview(nameTextLabel)
        nameTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        nameTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameTextLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        nameTextLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//        
//        addSubview(logoImageView)
//        logoImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
//        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        logoImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
