//
//  ProfileController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 22/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    struct Section {
        var name: String!
        var items: [String]!
        var collapsed: Bool!
        
        init(name: String, items: [String], collapsed: Bool = true) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserInfo()
        setupViews()
        
        
//        informationTable.delegate = self
//        informationTable.dataSource = self
//        informationTable.tableFooterView = UIView()
//        informationTable.allowsSelection = false
        
        profileScrollView.delegate = self
        
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if userToShow.id == uid {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_icon"), style: .plain, target: self, action: #selector(handleOptions))
            }
        }
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if userToShow.id == uid {
                profileScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            } else {
                profileScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonHeight + 20, right: 0)
            }
        }
        profileScrollView.resizeContentSize()
    }
    
    

    
    // MARK: - Variables
    var viewHeight: CGFloat = 0.0
    var viewWidth: CGFloat = 0.0
    var activitiesArray = [String]()
    var verifiedArray = [Int]()
    var userToShow = User()
    var selfProfile = false
    let buttonHeight: CGFloat = 52
    
    var sizingCell: TagCell = TagCell()
    
    var messagesController: MessagesController?

    var descriptionHeightConstraint, descriptionTopConstraint, profileTopConstraint, profileHeightConstraint: NSLayoutConstraint!
//    var activitiesTagCloudHeight: NSLayoutConstraint!
//    var moreInfoHeight: NSLayoutConstraint!
    let locationManager = CLLocationManager()
    var activities = [String: Int]()
    
    lazy var profileScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.white
        scroll.isScrollEnabled = true
        scroll.bounces = true
        scroll.backgroundColor = UIColor.rgb(r: 250, g: 250, b: 250, a: 1)
        return scroll
    }()
    
    lazy var profilePicture: UIImageView = {
        let screenSize = UIScreen.main.bounds
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "user")
        
        return iv
    }()
    
    let overlay: UIImageView = {
        let screenSize = UIScreen.main.bounds
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "overlay")
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: UIFontWeightRegular)
        //label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textColor = UIColor.white
        label.textAlignment = .left
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        label.textColor = UIColor.white
        label.textAlignment = .left
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: UIFontWeightSemibold)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    
    lazy var activitiesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isUserInteractionEnabled = false
        collection.backgroundColor = UIColor.yellow
        collection.delegate = self
        collection.contentInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        collection.dataSource = self
        return collection
    }()
    
    // MARK: - Methods
    func setupViews(){
        
        
        
        view.addSubview(profileScrollView)
        profileScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        profileScrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        profileScrollView.showsVerticalScrollIndicator = false
        profileScrollView.showsHorizontalScrollIndicator = false
        
        profileScrollView.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileTopConstraint = profilePicture.topAnchor.constraint(equalTo: profileScrollView.topAnchor)
        profileTopConstraint.isActive = true
        profilePicture.widthAnchor.constraint(equalTo: profileScrollView.widthAnchor).isActive = true
        profileHeightConstraint = profilePicture.heightAnchor.constraint(equalTo: profileScrollView.widthAnchor)
        profileHeightConstraint.isActive = true
    
        
        profilePicture.addSubview(overlay)
        overlay.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor).isActive = true
        overlay.rightAnchor.constraint(equalTo: profilePicture.rightAnchor).isActive = true
        overlay.leftAnchor.constraint(equalTo: profilePicture.leftAnchor).isActive = true
        overlay.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        overlay.addSubview(locationLabel)
        locationLabel.leftAnchor.constraint(equalTo: profilePicture.leftAnchor, constant:20).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: -20).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        overlay.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profilePicture.leftAnchor, constant: 20).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        profileScrollView.addSubview(captionLabel)
        captionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captionLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 20).isActive = true
        captionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        profileScrollView.addSubview(activitiesCollectionView)
        activitiesCollectionView.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 20).isActive = true
        activitiesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        activitiesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        activitiesCollectionView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
//        view.addSubview(descriptionLabel)
//        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        descriptionLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor).isActive = true
//        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
//        descriptionLabel.heightAnchor.constraint(equalToConstant: 67).isActive = true
        
//        descriptionHeightConstraint.isActive = true
//        descriptionTopConstraint.isActive = true
        
//        profileScrollView.addSubview(informationTable)
//        informationTable.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
//        informationTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        informationTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        informationTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        
        view.addSubview(sendMessageButton)
        sendMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendMessageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sendMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sendMessageButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
    }
    
    func loadUserInfo(){
        
        listenForChangesInProfile()
        
        if let profile = userToShow.profileImageURL {
            profilePicture.loadImageUsingCacheWithURLString(profile)
        }
        
        if let name = userToShow.name {
            nameLabel.text = name
        }
        
        if let tags = userToShow.tags {
            activitiesArray = tags.sorted()
        }
        
        if let verified = userToShow.verified {
            verifiedArray = verified
        }
        
        if let caption = userToShow.caption {
            print(caption)
            captionLabel.text = caption
        }
        if userToShow.id == FIRAuth.auth()?.currentUser?.uid {
            sendMessageButton.isHidden = true
        } else {
            sendMessageButton.setTitle(NSLocalizedString("SendMessage", comment: "Send message in profile view"), for: .normal)
        }
        
        sections = [
            Section(name: "ACTIVIDADES", items: activitiesArray, collapsed: false)
        ]
        
        for (index, element) in activitiesArray.enumerated() {
            activities[element] = verifiedArray[index]
            print(activities)
        }
        
        if let city = userToShow.cityName {
            locationLabel.text = city
        }
        
        let sortedDict = activities.sorted(by: { $0.0 < $1.0 })
        print(sortedDict)
        
    }
    
    func listenForChangesInProfile(){
        print("listen called with uid" + userToShow.id!)
        if let uid = userToShow.id {
            let ref = FIRDatabase.database().reference().child("users").child(uid)
            ref.observe(.childChanged, with: { (snapshot) in
                if snapshot.key == "city" {
                    self.locationLabel.text = snapshot.value as! String?
                }
                
                self.view.layoutIfNeeded()
            }, withCancel: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width / 2 - 22, height: 24)
        
        return size
    }
    
//    func autoSizeDescription(){
//        
//        if (descriptionLabel.requiredHeight() > 0){
//            
//            print(descriptionLabel.requiredHeight())
//            let topAndBottomConstant: CGFloat = 40
//            descriptionHeightConstraint.constant = descriptionLabel.requiredHeight() + topAndBottomConstant
//            profileScrollView.resizeContentSize()
//            
//        }
//        
//    }

}
