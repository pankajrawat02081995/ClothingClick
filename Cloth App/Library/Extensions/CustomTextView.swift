//
//  CustomTextView.swift
//  bookAVE
//
//  Created by Dharmesh on 16/11/19.
//  Copyright © 2019 bookAVE. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextView: UITextView {
    
    @IBInspectable var viewRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            if (newValue == -1) {
                self.layer.cornerRadius = self.bounds.size.height / 2;
            }
            else {
                self.layer.cornerRadius = newValue
            }
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

}
