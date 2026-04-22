//
//  String.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 27/05/24.
//

import Foundation
import UIKit

extension String {
    func width(withFont font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: attributes)
        return ceil(size.width)
    }
    
    func formatPrice() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        if let formattedPrice = numberFormatter.string(from: NSNumber(value: Int(self) ?? 0)),  formattedPrice != "0" {
            return formattedPrice
        } else {
            return "\(self)"
        }
    }
}

extension String {
    var htmlToPlainText: String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        return attributedString?.string ?? self
    }
}
