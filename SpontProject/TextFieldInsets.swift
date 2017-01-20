//
//  TextFieldInsets.swift
//  SpontProject
//
//  Created by Alex Sanchez on 13/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

class TextFieldInsets: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0);
    
    override func draw(_ rect: CGRect) {
        
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 2.0
        
        UIColor.lightGray.setStroke()
        
        path.stroke()
    }
    
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
