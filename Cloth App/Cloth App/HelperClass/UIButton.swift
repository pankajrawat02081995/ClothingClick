//
//  UIButton.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 28/05/24.
//

import Foundation
import UIKit

extension UIButton{
    
    func setAlpha(isSet:Bool){
        if isSet{
            self.alpha = 0.4
            self.isUserInteractionEnabled = false
        }else{
            self.alpha = 1
            self.isUserInteractionEnabled = true
        }
    }
}
