//
//  TextFieldInsets.swift
//  SpontProject
//
//  Created by Alex Sanchez on 13/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class TextFieldInsets: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 128);
    
    

    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

class EditProfileTextField: UITextField {
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect =  super.clearButtonRect(forBounds: bounds)
        rect.origin.x -= 8
        return rect
    }
}
