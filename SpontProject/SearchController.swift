//
//  SearchController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo_navbar")
        navigationItem.titleView = UIImageView(image: logo)
        view.backgroundColor = UIColor.white
        
        setupViews()
        activitiesTableView.isHidden = true
        
        delegatesSetup()
        loadListOfActivities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Variables
    var dataArray = [String]()
    var filteredArray = [String]()
    var topSearchArray = ["BODYPUMP", "BODYCOMBAT", "BODYBALANCE", "SH'BAM"]
    var shouldShowSearchResults = false
    
    var tableViewBottomConstraint: NSLayoutConstraint!
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = NSLocalizedString("SearchAnActivity", comment: "")
        search.autocapitalizationType = .allCharacters
        search.tintColor = UIColor.rgb(r: 254, g: 40, b: 81, a: 1)
        search.searchBarStyle = .minimal
        search.keyboardAppearance = .dark
        search.keyboardType = .alphabet
        return search
    }()
    
    lazy var activitiesTableView: UITableView = {
        let table = UITableView()
        table.register(LogoCell.self, forCellReuseIdentifier: "logoCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.white
        return table
    }()
    
    lazy var topSearchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width / 2) - 1 , height: (self.view.frame.width / 2) - 2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TopCell.self, forCellWithReuseIdentifier: "topActivityCell")
        collection.backgroundColor = UIColor.white
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    let topSearchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topSearchTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("TopSearch", comment: "")
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 36, weight: UIFontWeightBold)
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        return label
    }()
    
    let topSearchDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = NSLocalizedString("MostSearched", comment: "")
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        label.textColor = UIColor.rgb(r: 74, g: 74, b: 74, a: 1)
        return label
    }()
    
    func setupViews(){
        
        view.addSubview(searchBar)
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(topSearchCollectionView)
        topSearchCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topSearchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topSearchCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topSearchCollectionView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(topSearchView)
        topSearchView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topSearchView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        topSearchView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topSearchView.bottomAnchor.constraint(equalTo: topSearchCollectionView.topAnchor).isActive = true
        
        topSearchView.addSubview(topSearchDescription)
        topSearchDescription.leftAnchor.constraint(equalTo: topSearchView.leftAnchor, constant: 24).isActive = true
        topSearchDescription.topAnchor.constraint(equalTo: topSearchView.centerYAnchor, constant: 2).isActive = true
        topSearchDescription.rightAnchor.constraint(equalTo: topSearchView.rightAnchor, constant: -48).isActive = true
        topSearchDescription.heightAnchor.constraint(equalToConstant: 18)
        
        topSearchView.addSubview(topSearchTitle)
        topSearchTitle.leftAnchor.constraint(equalTo: topSearchView.leftAnchor, constant: 24).isActive = true
        topSearchTitle.bottomAnchor.constraint(equalTo: topSearchView.centerYAnchor, constant: -2).isActive = true
        topSearchTitle.rightAnchor.constraint(equalTo: topSearchView.rightAnchor, constant: -72).isActive = true
        topSearchTitle.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addSubview(activitiesTableView)
        activitiesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activitiesTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        activitiesTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        activitiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
    }
    
}
