//
//  SizeXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 15/10/25.
//

import UIKit

class SizeXIB: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.layer.cornerRadius = 4
            lblTitle.layer.borderColor = UIColor.appLightBorder.cgColor
            lblTitle.layer.borderWidth = 1
            lblTitle.backgroundColor = .appWhite
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
