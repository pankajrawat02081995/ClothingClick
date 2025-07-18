//
//  UserProfileListXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 23/06/24.
//

import UIKit
import IBAnimatable

class UserProfileListXIB: UITableViewCell {

    @IBOutlet weak var lblNameLetter: UILabel!
    @IBOutlet weak var imgUser: AnimatableImageView!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
