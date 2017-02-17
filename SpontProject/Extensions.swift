//
//  Extensions.swift
//  SpontProject
//
//  Created by Alex Sanchez on 12/12/16.
//  Copyright © 2016 Alex Sanchez. All rights reserved.
//

import UIKit

extension UIColor {

    static func rgb (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor{
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}

extension UILabel{
    
    func requiredHeight() -> CGFloat{
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = self.numberOfLines
        label.lineBreakMode = self.lineBreakMode
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        
        return label.frame.height
    }
    
}

//class TextField : UITextField {
//    
//    override func draw(_ rect: CGRect) {
//        
//        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY - 4)
//        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY - 4)
//        
//        let path = UIBezierPath()
//        
//        path.move(to: startingPoint)
//        path.addLine(to: endingPoint)
//        path.lineWidth = 2.0
//        
//        UIColor.lightGray.setStroke()
//        
//        path.stroke()
//    }
//}

class RegisterTextField: UITextField {
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

extension UIViewController {
//    func resizeToFitViews(scrollview: UIScrollView){
//        var width: CGFloat = 0
//        var height: CGFloat = 0
//        
//        for v in view.subviews {
//            let w = v.frame.origin.x + v.frame.size.width
//            let h = v.frame.origin.y + v.frame.size.height
//            
//            width = max(w, width)
//            height = max(h, height)
//            
//            
//        }
//        
//        scrollview.contentSize = CGSize(width: width, height: height)
//    }
    
    func resizeToFitViews(scrollview: UIScrollView) {
        var contentRect = CGRect.zero
        for view in scrollview.subviews {
            contentRect = contentRect.union(view.frame)
            print(contentRect.size)
            print(view)
        }
        
        
        
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: contentRect.size.height)
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithURLString(_ urlString: String) {
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) {
            self.image = cachedImage as? UIImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
            }
        }).resume()
    }
}

extension UIScrollView{
    func resizeContentSize(){
        
        var contentRect = CGRect.zero
        for view in self.subviews{
            contentRect = contentRect.union(view.frame)
        }
        
        self.contentSize = contentRect.size
        
    }
}

class IntrinsicSizeCollectionView: UICollectionView {
    // MARK: - lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.bounds.size.equalTo(self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let insets: CGFloat = 40
            let height = self.contentSize.height + insets
            let width = self.contentSize.width
            let intrinsicContentSize = CGSize(width: width, height: height)
            return intrinsicContentSize
        }
    }
    
    // MARK: - setup
    func setup() {
        self.isScrollEnabled = false
        self.bounces = false
    }
}
