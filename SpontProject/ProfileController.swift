//
//  ProfileController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 22/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
        descriptionLabel.isHidden = true
        profilePicture.image = UIImage(named: "oscar")
        
        activitiesTagCloud.delegate = self
        activitiesTagCloud.dataSource = self
        profileScrollView.delegate = self
        
        activitiesTagCloud.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        profileScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_icon"), style: .plain, target: self, action: #selector(handleOptions))
        
        activitySectionLabel.isHidden = true
        
        activityIndicator.startAnimating()
        sendMessageButton.setTitle("", for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        autoSizeDescription()
        scrollViewFit(scrollView: profileScrollView)
    }
    
    var viewHeight: CGFloat = 0.0
    var viewWidth: CGFloat = 0.0
    var activitiesArray = ["BODYATTACK", "BODYCOMBAT", "BODYJAM"]//, "BORN TO MOVE", "LES MILLS GRIT", "LES MILLS SPRINT", "BODYSTEP", "BODYPUMP", "BODYVIVE 3.1", "BODYBALANCE", "SH'BAM", "CXWORX", "RPM"]
    
    var sizingCell: TagCell = TagCell()

    var descriptionHeightConstraint, descriptionBottomConstraint, activityDescriptionHeight: NSLayoutConstraint!
    var activitiesTagCloudHeight: NSLayoutConstraint!
    var moreInfoHeight: NSLayoutConstraint!
    
    lazy var profileScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 244, a: 1)
        return scroll
    }()
    
    lazy var profilePicture: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
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
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        label.text = "Las Rozas, Madrid"
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        label.text = "Owner @smartclubtr (www.smart-club.es), REEBOK sponsored athlete, Les Mills Trainer, BeachBody LesMillsCombat & ETIXX Ambassador. Twitter@PeiroOscar"
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        label.textAlignment = .center
        
        return label
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
        button.setTitle("Enviar mensaje", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
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
        label.textAlignment = .center
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
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    lazy var activitiesTagCloud: UICollectionView = {
        let layout = CenterFlowLayout()
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
    
   

    func setupViews(){
        
        view.addSubview(profileScrollView)
        profileScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profileScrollView.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: profileScrollView.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo: profileScrollView.topAnchor, constant: 16).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        profileScrollView.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: profileScrollView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 16).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: profileScrollView.widthAnchor, constant: -40).isActive = true
        
        profileScrollView.addSubview(locationLabel)
        locationLabel.centerXAnchor.constraint(equalTo: profileScrollView.centerXAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: profileScrollView.widthAnchor, constant: -40).isActive = true
        
        profileScrollView.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: profileScrollView.centerXAnchor).isActive = true
        descriptionBottomConstraint = descriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 0)
        descriptionLabel.widthAnchor.constraint(equalTo: profileScrollView.widthAnchor, constant: -40).isActive = true
        descriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: 0)
        descriptionHeightConstraint.isActive = true
        descriptionBottomConstraint.isActive = true
        
        profileScrollView.addSubview(sendMessageButton)
        sendMessageButton.centerXAnchor.constraint(equalTo: profileScrollView.centerXAnchor).isActive = true
        sendMessageButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        sendMessageButton.widthAnchor.constraint(equalTo: profileScrollView.widthAnchor).isActive = true
        sendMessageButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        sendMessageButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: sendMessageButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: sendMessageButton.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 36).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        profileScrollView.addSubview(backgroundTagCells)
        profileScrollView.addSubview(activitySectionLabel)
        profileScrollView.addSubview(activityDescriptionLabel)
        profileScrollView.addSubview(activitiesTagCloud)
        activitySectionLabel.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 28).isActive = true
        activitySectionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        activitySectionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true
        activitySectionLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        activityDescriptionLabel.topAnchor.constraint(equalTo: activitySectionLabel.bottomAnchor, constant: 8).isActive = true
        activityDescriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        activityDescriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true
        activityDescriptionHeight = activityDescriptionLabel.heightAnchor.constraint(equalToConstant: 0)
        activityDescriptionHeight.isActive = true
        
        activitiesTagCloud.topAnchor.constraint(equalTo: activityDescriptionLabel.bottomAnchor, constant: 16).isActive = true
        activitiesTagCloud.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        activitiesTagCloudHeight = activitiesTagCloud.heightAnchor.constraint(equalToConstant: 0)
        activitiesTagCloudHeight.isActive = true
        activitiesTagCloud.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true
        
        backgroundTagCells.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 16).isActive = true
        backgroundTagCells.bottomAnchor.constraint(equalTo: activitiesTagCloud.bottomAnchor, constant: 16).isActive = true
        backgroundTagCells.leftAnchor.constraint(equalTo: activitiesTagCloud.leftAnchor, constant: -16).isActive = true
        backgroundTagCells.rightAnchor.constraint(equalTo: activitiesTagCloud.rightAnchor, constant: 16).isActive = true
        
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
        sendMessageButton.setTitle(NSLocalizedString("SendMessage", comment: "Send message in profile view"), for: .normal)
    }

}
