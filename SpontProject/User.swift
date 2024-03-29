//
//  User.swift
//  SpontProject
//
//  Created by Alex Sanchez on 15/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import Foundation

class User: NSObject {
    var id: String?
    var name: String?
    var username: String?
    var caption: String?
    var email: String?
    var phone: String?
    var profileImageURL: String?
    var distance: Double?
    var city: String?
    var street: String?
    var tags: [String]?
    var verified: [Int]?
    var activities: [String: Int]?
}
