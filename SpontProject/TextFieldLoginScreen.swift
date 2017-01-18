//
//  TextFieldLoginScreen.swift
//  Cover
//
//  Created by Alex Sanchez on 30/10/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//
import UIKit

class TextFieldLoginScreen: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func createTextFieldWith(placeholder: String) {
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.black.withAlphaComponent(0.6)])
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        textColor = UIColor.black
        font = UIFont.systemFont(ofSize: 14)
        clearButtonMode = UITextFieldViewMode.whileEditing
        autocapitalizationType = .none
        autocorrectionType = .no
        tintColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 16, y: bounds.origin.y, width: bounds.width - 48, height: bounds.height)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 32, y: bounds.origin.y, width: 16, height: bounds.height)
    }
    
}
