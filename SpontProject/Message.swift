//
//  Message.swift
//  SpontProject
//
//  Created by Alex Sanchez on 6/1/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var from: String?
    var to: String?
    var text: String?
    var timestamp: NSNumber?
    var read: Bool?
    
    func chatPartnerId() -> String? {
        
        if from == FIRAuth.auth()?.currentUser?.uid {
            return to
        } else {
            return from
        }
    }
}
