//
//  Filters.swift
//  SpontProject
//
//  Created by Alex Sanchez on 26/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import CoreLocation

class Filters {
    static let sharedInstance = Filters()
    private init(){}
    
    let locationManager = CLLocationManager()
}
