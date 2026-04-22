//
//  CustomTextField.swift
//  DriveMeDriver
//
//  Created by Hardik Shekhat on 08/07/18.
//  Copyright © 2018 Hardik Shekhat. All rights reserved.
//

import UIKit
@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue {
                self.addShadow()
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var inset: CGFloat = 0
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: 0).offsetBy(dx: leftView?.frame.width ?? 0, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: inset, y: 0, width: bounds.height, height: bounds.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - (rightView?.frame.width ?? 0), y: 0, width: bounds.height, height: bounds.height)
    }
    
    private func updateView() {
        if let image = leftImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
            imageView.image = image
            imageView.contentMode = .center
            leftView = imageView
            leftViewMode = .always
        } else {
            leftView = nil
        }
        
        if let image = rightImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
            imageView.image = image
            imageView.contentMode = .center
            rightView = imageView
            rightViewMode = .always
        } else {
            rightView = nil
        }
    }
}

//@IBDesignable
//class CustomTextField: UITextField {
//    
//    @IBInspectable var shadow: Bool {
//        get {
//            return layer.shadowOpacity > 0.0
//        }
//        set {
//            if newValue == true {
//                self.addShadow()
//            }
//        }
//    }
//    
//    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
//                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
//                   shadowOpacity: Float = 0.4,
//                   shadowRadius: CGFloat = 3.0) {
//        layer.shadowColor = shadowColor
//        layer.shadowOffset = shadowOffset
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowRadius = shadowRadius
//    }
//
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
//        }
//    }
//    
//    @IBInspectable var placeholderColor: UIColor {
//        get {
//            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
//        }
//        set {
//            guard let attributedPlaceholder = attributedPlaceholder else { return }
//            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
//            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
//        }
//    }
//    
//    @IBInspectable var borderWidth: CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    
//    @IBInspectable var borderColor: UIColor? {
//        didSet {
//            layer.borderColor = borderColor?.cgColor
//        }
//    }
//    
//    @IBInspectable var inset: CGFloat = 0
//    
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: inset, dy: bounds.origin.y)
//    }
//    
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return textRect(forBounds: bounds)
//    }
//}
