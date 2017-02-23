//
//  ActivityCell.swift
//  SpontProject
//
//  Created by Alex Sanchez on 15/2/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    
    let nameTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        return label
    }()
    
//    let logoImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.image = UIImage(named: "not-verified")
//        iv.contentMode = .scaleAspectFit
//        return iv
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    func setupViews(){
        
//        addSubview(logoImageView)
//        logoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        logoImageView.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
//        logoImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(nameTextLabel)
        nameTextLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nameTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameTextLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameTextLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
