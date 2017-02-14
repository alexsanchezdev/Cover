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
        label.text = "Nunca publicaremos tu dirección. Sólo usaremos estos datos para mostrarte en los resultados de búsqueda."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
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
        button.setTitle("Actualizar ubicación", for: .normal)
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
        view.addSubview(warningLabel)
        warningLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        warningLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        warningLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 16).isActive = true
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
        
        
    }
    
    func updateLocation(){
        
        
        
        guard let location = Filters.sharedInstance.locationManager.location else { return }
        userToChangeLocation.userLocation = location
        
        let loading = UIAlertController(title: nil, message: "Actualizando ubicación...", preferredStyle: .alert)
        let done = UIAlertController(title: nil, message: "Ubicación actualizada", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        done.addAction(ok)
        
        let geoFireRef = FIRDatabase.database().reference().child("locations")
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        
        loading.view.tintColor = UIColor.black
        present(loading, animated: true, completion: {
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                geoFire?.setLocation(location, forKey: uid)
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                    if error != nil {
                        print(error!)
                    }
                    
                    let placemark = placemarks?[0]
                    self.userToChangeLocation.cityName = placemark?.locality 
                    self.userToChangeLocation.streetName = placemark?.thoroughfare as String?
                    self.editProfileController.locationLabel.text = self.userToChangeLocation.cityName! + ", " + self.userToChangeLocation.streetName!
                    if let uid = FIRAuth.auth()?.currentUser?.uid{
                        let ref = FIRDatabase.database().reference().child("users").child(uid)
                        ref.updateChildValues(["city": self.userToChangeLocation.cityName!, "street": self.userToChangeLocation.streetName!], withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print(error!)
                            } else {
                                self.dismiss(animated: true, completion: {
                                    self.present(done, animated: true, completion: nil)
                                })
                            }
                        })
                    }
                })
            }
        })
        
        
    }
}
