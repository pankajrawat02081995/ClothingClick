//
//  UIFont.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 04/06/24.
//

import Foundation

extension UIFont {
    
    public enum Roboto: String {
        case robotoMedium = "Roboto-Medium"
        case robotoLight = "Roboto-Light"
        case robotoRegular = "Roboto-Regular"
        case robotoMediumItalic = "Roboto-MediumItalic"
        case robotoThinItalic = "Roboto-ThinItalic"
        case robotoBoldItalic = "Roboto-BoldItalic"
        case robotoLightItalic = "Roboto-LightItalic"
        case robotoBlackItalic = "Roboto-BlackItalic"
        case robotoBold = "Roboto-Bold"
        case robotoThin = "Roboto-Thin"
        case robotoBlack = "Roboto-Black"
        case robotoRegularItalic = "Roboto-RegularItalic"
    }
    
    static func RobotoFont(_ type: Roboto = .robotoRegular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "\(type.rawValue)", size: size)!
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
}
