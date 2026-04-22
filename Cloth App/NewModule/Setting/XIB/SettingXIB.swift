//
//  SettingXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 11/06/24.
//

import UIKit

class SettingXIB: UITableViewCell {
    
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnToggle: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
