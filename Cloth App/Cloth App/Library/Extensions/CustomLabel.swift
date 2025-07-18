//
//  CustomTextField.swift
//  DriveMeDriver
//
//  Created by Hardik Shekhat on 08/07/18.
//  Copyright © 2018 Hardik Shekhat. All rights reserved.
//

import UIKit

@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
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
    
//    var topInset: CGFloat
//    var bottomInset: CGFloat
//    var leftInset: CGFloat
//    var rightInset: CGFloat
//
//    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
//        self.topInset = top
//        self.bottomInset = bottom
//        self.leftInset = left
//        self.rightInset = right
//        super.init(frame: CGRect.zero)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func drawText(in rect: CGRect) {
//        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//    }
//
//    override var intrinsicContentSize: CGSize {
//        get {
//            var contentSize = super.intrinsicContentSize
//            contentSize.height += topInset + bottomInset
//            contentSize.width += leftInset + rightInset
//            return contentSize
//        }
//    }
    
}

