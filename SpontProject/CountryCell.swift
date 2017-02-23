//
//  CountryCell.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/2/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    let nameTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        return label
    }()
    
    let numberTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorInset = UIEdgeInsets.zero
        backgroundColor = UIColor.clear
        setupViews()
    }
    
    
    func setupViews(){
        
        addSubview(numberTextLabel)
        numberTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        numberTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        numberTextLabel.widthAnchor.constraint(equalToConstant: 48).isActive = true
        numberTextLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    
        addSubview(nameTextLabel)
        nameTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        nameTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameTextLabel.rightAnchor.constraint(equalTo: numberTextLabel.leftAnchor).isActive = true
        nameTextLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
