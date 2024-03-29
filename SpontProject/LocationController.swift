//
//  LocationController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 13/2/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class LocationController: UIViewController, MKMapViewDelegate {
    
    var editProfileController = EditProfileController()
    var userToChangeLocation = User()

    let warningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("WillNotShareLocation", comment: "")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        return map
    }()
    
    lazy var updateLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("UpdateLocation", comment: ""), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 255, g: 45, b: 85, a: 1), for: .normal)
        button.setTitleColor(UIColor.rgb(r: 255, g: 45, b: 85, a: 0.25), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(updateLocation), for: .touchUpInside)
        return button
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1)
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230, a: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 250, g: 250, b: 250, a: 1)
        
        setupViews()
        mapView.delegate = self
        
        Filters.sharedInstance.locationManager.startUpdatingLocation()
        let camera = MKMapCamera(lookingAtCenter: (Filters.sharedInstance.locationManager.location?.coordinate)!, fromDistance: 1000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let camera = MKMapCamera(lookingAtCenter: (Filters.sharedInstance.locationManager.location?.coordinate)!, fromDistance: 1000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Filters.sharedInstance.locationManager.stopUpdatingLocation()
    }
    
    func setupViews(){
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16).isActive = true
        
        view.addSubview(topSeparatorView)
        topSeparatorView.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        topSeparatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topSeparatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(updateLocationButton)
        updateLocationButton.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor).isActive = true
        updateLocationButton.leftAnchor.constraint(equalTo: mapView.leftAnchor).isActive = true
        updateLocationButton.rightAnchor.constraint(equalTo: mapView.rightAnchor).isActive = true
        updateLocationButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(bottomSeparatorView)
        bottomSeparatorView.topAnchor.constraint(equalTo: updateLocationButton.bottomAnchor).isActive = true
        bottomSeparatorView.leftAnchor.constraint(equalTo: updateLocationButton.leftAnchor).isActive = true
        bottomSeparatorView.rightAnchor.constraint(equalTo: updateLocationButton.rightAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(warningLabel)
        warningLabel.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 16).isActive = true
        warningLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        warningLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
    }
    
    func updateLocation(){
        
        let group = DispatchGroup()
        
        guard let location = Filters.sharedInstance.locationManager.location else { return }
    
        let loading = UIAlertController(title: nil, message: NSLocalizedString("UpdatingLocation", comment: ""), preferredStyle: .alert)
        let done = UIAlertController(title: nil, message: NSLocalizedString("LocationUpdated", comment: ""), preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        done.addAction(ok)
        
        let geoFireRef = FIRDatabase.database().reference().child("locations")
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        
        loading.view.tintColor = UIColor.black
        present(loading, animated: true, completion: {
            group.enter()
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                geoFire?.setLocation(location, forKey: uid)
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                    if error != nil {
                        print(error!)
                    }
                    
                    let placemark = placemarks?[0]
                    
                    if let city = placemark?.locality {
                        self.userToChangeLocation.city = city
                        self.editProfileController.locationLabel.text = self.userToChangeLocation.city
                        print(city)
                        
                        if let street = placemark?.thoroughfare {
                            self.userToChangeLocation.street = street
                            self.editProfileController.locationLabel.text = street + ", " + city
                            print(street)
                        } else {
                            self.userToChangeLocation.street = nil
                        }
                        
                        
                        group.leave()
                    } else {
                        self.userToChangeLocation.city = nil
                    }
                    
                    group.notify(queue: DispatchQueue.main) {
                        
                        let ref = FIRDatabase.database().reference().child("users").child(uid)
                        
                        if let city = self.userToChangeLocation.city {
                            if let street = self.userToChangeLocation.street {
                                ref.updateChildValues(["city": city, "street": street], withCompletionBlock: { (error, ref) in
                                    if error != nil {
                                        print(error!)
                                    } else {
                                        self.dismiss(animated: true, completion: {
                                            self.present(done, animated: true, completion: nil)
                                        })
                                    }
                                    
                                })
                            }
                            
                            ref.updateChildValues(["city": city], withCompletionBlock: { (error, ref) in
                                if error != nil {
                                    print(error!)
                                } else {
                                    if self.userToChangeLocation.street == nil {
                                        ref.child("street").removeValue()
                                    }

                                    self.dismiss(animated: true, completion: {
                                        self.present(done, animated: true, completion: nil)
                                    })
                                }
                                
                            })
                            
                        }
                    }
                })
            }
        })
        
        
    }
}
