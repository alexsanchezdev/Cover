//
//  TopCell.swift
//  SpontProject
//
//  Created by Alex Sanchez on 21/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class TopCell: UICollectionViewCell {
    
    let activityTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textAlignment = .center
        return label
    }()
    
    let activityImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        //iv.layer.masksToBounds = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        setupViews()
    }
    
    func setupViews(){
        
        addSubview(activityImageView)
        activityImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16).isActive = true
        activityImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
        activityImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2).isActive = true
        
        addSubview(activityTitle)
        activityTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityTitle.topAnchor.constraint(equalTo: activityImageView.bottomAnchor, constant: 16).isActive = true
        activityTitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 5/6).isActive = true
        activityTitle.heightAnchor.constraint(equalToConstant: 16).isActive = true
    
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
