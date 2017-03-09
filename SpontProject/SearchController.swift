//
//  SearchController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit
import OneSignal

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo_navbar")
        navigationItem.titleView = searchBar//UIImageView(image: logo)
        view.backgroundColor = UIColor.white
        
        setupViews()
        activitiesTableView.isHidden = true
        
        delegatesSetup()
        loadListOfActivities()
        
        print(view.frame.height)
        if view.frame.height <= 480.0 {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    promptOpenSettings()
                case .authorizedAlways, .authorizedWhenInUse:
                    Filters.sharedInstance.locationManager.startUpdatingLocation()
            }
        } else {
            promptLocationServices()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Filters.sharedInstance.locationManager.stopUpdatingLocation()
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
        layout.itemSize = CGSize(width: self.view.frame.width - 32 , height: 150)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TopCell.self, forCellWithReuseIdentifier: "topActivityCell")
        collection.backgroundColor = UIColor.white
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()

    


    
    func setupViews(){
        
        view.addSubview(topSearchCollectionView)
        topSearchCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topSearchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topSearchCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topSearchCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(activitiesTableView)
        activitiesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activitiesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activitiesTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        activitiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
    }
    
    func promptOpenSettings(){
        let alertController = UIAlertController(
            title: "Localización desactivada",
            message: "\nPara poder mostrarte resultados cercanos a ti es necesario que tengas activada la localización. \n\nPor favor, abre la configuración de la aplicación y selecciona 'Al usarse'",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Abrir configuración", style: .default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url as URL)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func promptLocationServices(){
        let alertController = UIAlertController(
            title: "Localización desactivada",
            message: "\nPara poder mostrarte resultados cercanos a ti es necesario que tengas activada la localización. \n\nVe a Ajustes > Privacidad > Localización y actívala.",
            preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
