//
//  TagCell.swift
//  SpontProject
//
//  Created by Alex Sanchez on 22/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    var tagNameMaxWidthConstraint: NSLayoutConstraint!
    
    let tagName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        tagName.textColor = UIColor.rgb(r: 90, g: 90, b: 90, a: 1)
        tagName.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 1/28, weight: UIFontWeightMedium)
        layer.cornerRadius = 4
        setupViews()
        tagNameMaxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
    }
    
    func setupViews(){
        addSubview(tagName)
        tagName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        tagName.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        tagName.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        tagName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        _ = NSLayoutConstraint(item: tagName, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        tagNameMaxWidthConstraint = NSLayoutConstraint(item: tagName, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 304)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
