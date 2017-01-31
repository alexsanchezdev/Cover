//
//  UserCell.swift
//  SpontProject
//
//  Created by Alex Sanchez on 13/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK: - Variables
    // Temp activities arrays while Firebase get implemented
    var tags = [String]()
    var verified = [Int]()
    // Sizing cell template to calculate size of cell on content
    var sizingCell: UserTagCell = UserTagCell()
    
    // MARK: - UI Elements
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "user")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 32
        return iv
    }()
    let nameTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    let usernameTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.rgb(r: 143, g: 142, b: 148, a: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let locationTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "49.7 km"
        label.textColor = UIColor.rgb(r: 143, g: 142, b: 148, a: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    lazy var activitiesTagCloud: UICollectionView = {
        let layout = TagFlowLayout()
        layout.minimumInteritemSpacing = 4
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UserTagCell.self, forCellWithReuseIdentifier: "userTagCell")
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isUserInteractionEnabled = false
        return collection
    }()
    
    let arrowImg: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "arrow")
        return img
    }()
    
    // Custom init for user cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        activitiesTagCloud.delegate = self
        activitiesTagCloud.dataSource = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI layouts setup
    func setupViews(){
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        addSubview(nameTextLabel)
        nameTextLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -76).isActive = true
        nameTextLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        addSubview(usernameTextLabel)
        usernameTextLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameTextLabel.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor, constant: 4).isActive = true
        usernameTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -76).isActive = true
        usernameTextLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        addSubview(locationTextLabel)
        locationTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        locationTextLabel.centerYAnchor.constraint(equalTo: nameTextLabel.centerYAnchor).isActive = true
        locationTextLabel.leftAnchor.constraint(equalTo: nameTextLabel.rightAnchor, constant: 8).isActive = true
        locationTextLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        addSubview(activitiesTagCloud)
        activitiesTagCloud.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        activitiesTagCloud.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        activitiesTagCloud.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        activitiesTagCloud.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(arrowImg)
        arrowImg.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        arrowImg.centerYAnchor.constraint(equalTo: activitiesTagCloud.centerYAnchor).isActive = true
        arrowImg.heightAnchor.constraint(equalToConstant: 16).isActive = true
        arrowImg.widthAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    // MARK: - Delegates collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0
        
        if tags.count == 1 {
            numberOfItems = 1
        } else if tags.count >= 2 {
            numberOfItems = 2
        }
        
        return numberOfItems
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userTagCell", for: indexPath) as! UserTagCell
        var activate = 0
        
        if indexPath.row == 0 {
            cell.tagName.text = tags[indexPath.row]
            if verified[indexPath.row] == 1 {
                cell.backgroundColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 0.25)
                cell.layer.borderColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1).cgColor
                cell.layer.borderWidth = 1
                cell.tagName.textColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
            }
        } else {
            cell.tagName.text = "+ \(tags.count - 1) MÁS"
            
            for (index, value) in verified.enumerated() {
                if index != 0 {
                    activate = activate + value
                    
                    if activate > 0 {
                        cell.backgroundColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 0.25)
                        cell.layer.borderColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1).cgColor
                        cell.layer.borderWidth = 1
                        cell.tagName.textColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
                    }
                }
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            sizingCell.tagName.text = tags[indexPath.row]
        } else {
            sizingCell.tagName.text = "+ \(tags.count - 1) MÁS"
        }
        return self.sizingCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
}
