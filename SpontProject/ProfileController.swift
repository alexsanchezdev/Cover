//
//  ProfileController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 22/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, CollapsibleTableViewHeaderDelegate {
    
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
        
        informationTable.delegate = self
        informationTable.dataSource = self
        informationTable.tableFooterView = UIView()
        informationTable.allowsSelection = false
        
        descriptionLabel.isHidden = true
        
        
        
//        activitiesTagCloud.delegate = self
//        activitiesTagCloud.dataSource = self
//        profileScrollView.delegate = self
        
//        activitiesTagCloud.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//        profileScrollView.contentInset = UIEdgeInsets(top: 0, left: -9, bottom: -50, right: -9)
//        profileScrollView.alwaysBounceVertical = true
//        profileScrollView.alwaysBounceHorizontal = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_icon"), style: .plain, target: self, action: #selector(handleOptions))
        
//        activitySectionLabel.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        autoSizeDescription()
        
    }

    
    // MARK: - Variables
    var viewHeight: CGFloat = 0.0
    var viewWidth: CGFloat = 0.0
    var activitiesArray = [String]()
    var verifiedArray = [Int]()
    var userToShow = User()
    var selfProfile = false
    
    var sizingCell: TagCell = TagCell()
    
    var messagesController: MessagesController?

    var descriptionHeightConstraint, descriptionTopConstraint, activityDescriptionHeight: NSLayoutConstraint!
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
        return scroll
    }()
    
    lazy var profilePicture: UIImageView = {
        let screenSize = UIScreen.main.bounds
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.red
        
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
        label.text = "Torre del Mar"
        return label
    }()

    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textAlignment = .center
        label.backgroundColor = UIColor.red
        
        return label
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    
    let informationTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
   
    // MARK: - Methods
    func setupViews(){
        
        let screenSize = UIScreen.main.bounds
        
        view.addSubview(profileScrollView)
        profileScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        profileScrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        profileScrollView.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo: profileScrollView.topAnchor).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        
        let layer = CAGradientLayer()
        let gradientHeight: CGFloat = 150
        layer.frame = CGRect(x: 0, y: view.bounds.width - gradientHeight, width: view.bounds.width, height: gradientHeight)
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        profilePicture.layer.addSublayer(layer)
        
        profilePicture.addSubview(locationLabel)
        locationLabel.leftAnchor.constraint(equalTo: profilePicture.leftAnchor, constant:20).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: -20).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        profilePicture.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profilePicture.leftAnchor, constant: 20).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        profileScrollView.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionTopConstraint = descriptionLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor)
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        descriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: 0)
        descriptionHeightConstraint.isActive = true
        descriptionTopConstraint.isActive = true
        
//        profileScrollView.addSubview(informationTable)
//        informationTable.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
//        informationTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        informationTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        informationTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        
//        view.addSubview(sendMessageButton)
//        sendMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        sendMessageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        sendMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        sendMessageButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
//        
//        sendMessageButton.addSubview(activityIndicator)
//        activityIndicator.centerXAnchor.constraint(equalTo: sendMessageButton.centerXAnchor).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: sendMessageButton.centerYAnchor).isActive = true
//        activityIndicator.widthAnchor.constraint(equalToConstant: 36).isActive = true
//        activityIndicator.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    func loadUserInfo(){
        
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
            descriptionLabel.text = caption
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
        
        let sortedDict = activities.sorted(by: { $0.0 < $1.0 })
        print(sortedDict)
        
    }
    
    func autoSizeDescription(){
        
        if (descriptionLabel.requiredHeight() > 0){
            
            print(descriptionLabel.requiredHeight())
            let topAndBottomConstant: CGFloat = 40
            descriptionHeightConstraint.constant = descriptionLabel.requiredHeight() + topAndBottomConstant
            profileScrollView.resizeContentSize()
            
        }
        
    }

}
