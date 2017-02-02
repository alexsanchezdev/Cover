//
//  ProfileController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 22/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserInfo()
        setupViews()
        
        descriptionLabel.isHidden = true
        
        activitiesTagCloud.delegate = self
        activitiesTagCloud.dataSource = self
        profileScrollView.delegate = self
        
        activitiesTagCloud.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        profileScrollView.contentInset = UIEdgeInsets(top: 0, left: -9, bottom: -10, right: -9)
        profileScrollView.alwaysBounceVertical = true
        profileScrollView.alwaysBounceHorizontal = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_icon"), style: .plain, target: self, action: #selector(handleOptions))
        
        activitySectionLabel.isHidden = true
        
        activityIndicator.startAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(profileScrollView.frame.height)
        resizeToFitViews(scrollview: profileScrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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

    var descriptionHeightConstraint, descriptionBottomConstraint, activityDescriptionHeight: NSLayoutConstraint!
    var activitiesTagCloudHeight: NSLayoutConstraint!
    var moreInfoHeight: NSLayoutConstraint!
    let locationManager = CLLocationManager()
    
    lazy var profileScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.white
        return scroll
    }()
    
    lazy var profilePicture: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "user")
        iv.layer.cornerRadius = 50
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.rgb(r: 151, g: 151, b: 151, a: 1).cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textAlignment = .center
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
        
        return label
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(updateCurrentLocation), for: .touchUpInside)
        return button
    }()
    
    let profileCardBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        return view
    }()
    
    let activitySectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Actividades"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightBold)
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textAlignment = .left
        return label
    }()
    
    let activityDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        label.text = "Estas son las actividades introducidas por el instructor. Confirmalas cuando os pongais en contacto."
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    lazy var activitiesTagCloud: UICollectionView = {
        let layout = TagFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TagCell.self, forCellWithReuseIdentifier: "activitiesTagCell")
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let backgroundTagCells: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
        view.layer.shouldRasterize = true
        return view
    }()
    
    let userBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        return view
    }()
    
   
    // MARK: - Methods
    func setupViews(){
        
        view.addSubview(profileScrollView)
        profileScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profileScrollView.addSubview(userBackground)
        
        profileScrollView.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo: profileScrollView.topAnchor, constant: 20).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        profileScrollView.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 20).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        profileScrollView.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionBottomConstraint = descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0)
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        descriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: 0)
        descriptionHeightConstraint.isActive = true
        descriptionBottomConstraint.isActive = true
        
        profileScrollView.addSubview(sendMessageButton)
        sendMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendMessageButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        sendMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sendMessageButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        userBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        userBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        userBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        userBackground.bottomAnchor.constraint(equalTo: sendMessageButton.topAnchor).isActive = true
        
        sendMessageButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: sendMessageButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: sendMessageButton.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 36).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        profileScrollView.addSubview(activitySectionLabel)
        profileScrollView.addSubview(activityDescriptionLabel)
        profileScrollView.addSubview(activitiesTagCloud)
        activitySectionLabel.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 20).isActive = true
        activitySectionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        activitySectionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        activitySectionLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        activityDescriptionLabel.topAnchor.constraint(equalTo: activitySectionLabel.bottomAnchor, constant: 8).isActive = true
        activityDescriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        activityDescriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        activityDescriptionHeight = activityDescriptionLabel.heightAnchor.constraint(equalToConstant: 0)
        activityDescriptionHeight.isActive = true
        
        activitiesTagCloud.topAnchor.constraint(equalTo: activityDescriptionLabel.bottomAnchor, constant: 16).isActive = true
        activitiesTagCloud.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        activitiesTagCloudHeight = activitiesTagCloud.heightAnchor.constraint(equalToConstant: 0)
        activitiesTagCloudHeight.isActive = true
        activitiesTagCloud.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        
    }
    
    func loadUserInfo(){
        
        if let profile = userToShow.profileImageURL {
            profilePicture.loadImageUsingCacheWithURLString(profile)
        }
        
        if let name = userToShow.name {
            nameLabel.text = name
        }
        
        if let tags = userToShow.tags {
            activitiesArray = tags
        }
        
        if let verified = userToShow.verified {
            verifiedArray = verified
        }
        
        if let caption = userToShow.caption {
            descriptionLabel.text = caption
        }
        if userToShow.id == FIRAuth.auth()?.currentUser?.uid {
            sendMessageButton.setTitle(NSLocalizedString("EditInfo", comment: "Edit information from profile view"), for: .normal)
        } else {
            sendMessageButton.setTitle(NSLocalizedString("SendMessage", comment: "Send message in profile view"), for: .normal)
        }
    }
    
    func autoSizeDescription(){
        activityDescriptionHeight.constant = activityDescriptionLabel.requiredHeight()
        
        if (descriptionLabel.requiredHeight() > 0){
            descriptionHeightConstraint.constant = descriptionLabel.requiredHeight()
            descriptionBottomConstraint.constant = 16
        }
    
        activitiesTagCloudHeight.constant = activitiesTagCloud.contentSize.height
        descriptionLabel.isHidden = false
        activitySectionLabel.isHidden = false
        activityIndicator.stopAnimating()
        
    }

}
