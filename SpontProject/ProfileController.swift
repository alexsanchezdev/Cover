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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserInfo()

        
        profileScrollView.delegate = self
        
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if userToShow.id == uid {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_icon"), style: .plain, target: self, action: #selector(handleOptions))
                profileScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            } else {
                profileScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonHeight, right: 0)
            }
        }
        
        setupViews()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //profileScrollView.resizeContentSize()
        self.viewDidLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileScrollView.resizeContentSize()
        
        //collectionHeight.constant = activitiesCollectionView.contentSize.height + 40
        //profileScrollView.resizeContentSize()
        //profileScrollView.contentSize.height = profileScrollView.contentSize.height - 20
    
    }
    
    // MARK: - Variables
    var activitiesArray = [String]()
    var verifiedArray = [Int]()
    var userToShow = User()
    var selfProfile = false
    let buttonHeight: CGFloat = 52
    var sortedDict = [(key: String, value: Int)]()

    var messagesController: MessagesController?

    var descriptionHeightConstraint, descriptionTopConstraint, profileTopConstraint, profileHeightConstraint, collectionHeight: NSLayoutConstraint!
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

    
    lazy var activitiesCollectionView: IntrinsicSizeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 4
        
        let collection = IntrinsicSizeCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ActivityCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = UIColor.white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isUserInteractionEnabled = false
        collection.delegate = self
        collection.contentInset = UIEdgeInsets(top: 20, left: 21, bottom: 0, right: 21)
        collection.dataSource = self
        collection.layer.borderColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1).cgColor
        collection.layer.borderWidth = 1
        return collection
    }()
    
    // MARK: - Methods
    func setupViews(){
        
        listenForChangesInProfile()
        
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
        activitiesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -1).isActive = true
        activitiesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 1).isActive = true
        //collectionHeight = activitiesCollectionView.heightAnchor.constraint(equalToConstant: 0)
        //collectionHeight.isActive = true
 
        view.addSubview(sendMessageButton)
        sendMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendMessageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sendMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sendMessageButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
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
            
            captionLabel.text = caption
        }
        if userToShow.id == FIRAuth.auth()?.currentUser?.uid {
            sendMessageButton.isHidden = true
        } else {
            sendMessageButton.setTitle(NSLocalizedString("SendMessage", comment: "Send message in profile view"), for: .normal)
        }
        
        for (index, element) in activitiesArray.enumerated() {
            activities[element] = verifiedArray[index]
        }
        
        if let city = userToShow.city {
            locationLabel.text = city
        } else {
            locationLabel.text = "Sin localización"
        }
        
        sortedDict = activities.sorted(by: { $0.0 < $1.0 })
        
    }
    
    func listenForChangesInProfile(){
        print("listen called with uid" + userToShow.id!)
        if let uid = userToShow.id {
            let ref = FIRDatabase.database().reference().child("users").child(uid)
            ref.observe(.childChanged, with: { (snapshot) in
                if snapshot.key == "city" {
                    self.locationLabel.text = snapshot.value as! String?
                    self.userToShow.city = self.locationLabel.text
                }
                
                if snapshot.key == "street" {
                    self.userToShow.street = snapshot.value as! String?
                }
                
                if snapshot.key == "activities" {
                    self.activities = snapshot.value as! [String : Int]
                    self.userToShow.activities = self.activities
                    self.sortedDict = self.activities.sorted(by: { $0.0 < $1.0 })
                }
                
                if snapshot.key == "name" {
                    self.nameLabel.text = snapshot.value as! String?
                    self.userToShow.name = self.nameLabel.text
                }
                
                if snapshot.key == "caption" {
                    self.captionLabel.text = snapshot.value as! String?
                    self.userToShow.caption = self.captionLabel.text
                }
                
                if snapshot.key == "username" {
                    self.navigationItem.title = snapshot.value as! String?
                    self.userToShow.username = self.navigationItem.title
                }
                
                if snapshot.key == "profileImg" {
                    self.profilePicture.loadImageUsingCacheWithURLString(snapshot.value as! String)
                    self.userToShow.profileImageURL = snapshot.value as! String?
                }
                
                self.activitiesCollectionView.reloadData()
                self.view.layoutIfNeeded()
                
            }, withCancel: nil)
            
            ref.observe(.childRemoved, with: { (snapshot) in
                if snapshot.key == "street" {
                    self.userToShow.street = nil
                }
                
                if snapshot.key == "activities" {
                    self.userToShow.activities = nil
                    self.sortedDict.removeAll()
                }
                
                if snapshot.key == "city" {
                    self.userToShow.city = nil
                    self.locationLabel.text = "Sin localización"
                }
                
                self.activitiesCollectionView.reloadData()
                self.view.layoutIfNeeded()
            }, withCancel: nil)
            
            ref.observe(.childAdded, with: { (snapshot) in
                print(snapshot)
                
                if snapshot.key == "activities" {
                    self.activities = snapshot.value as! [String: Int]
                    self.userToShow.activities = self.activities
                    self.sortedDict = self.activities.sorted(by: {$0.0 < $1.0})
                }
                
                if snapshot.key == "city" {
                    self.locationLabel.text = snapshot.value as! String?
                    self.userToShow.city = self.locationLabel.text
                }
                
                if snapshot.key == "street" {
                    self.userToShow.street = snapshot.value as! String?
                }
                
                self.activitiesCollectionView.reloadData()
                self.view.layoutIfNeeded()
            }, withCancel: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ActivityCell
        cell.nameTextLabel.text = sortedDict[indexPath.row].key
        
        if sortedDict[indexPath.row].value == 1 {
            cell.nameTextLabel.textColor = UIColor.rgb(r: 255, g: 45, b: 85, a: 1)
            cell.nameTextLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
        } else {
            cell.nameTextLabel.textColor = UIColor.black
            cell.nameTextLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width / 2 - 24, height: 24)
        
        return size
    }

}
