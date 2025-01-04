//
//  UserListXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 09/09/24.
//

import UIKit
import IBAnimatable
class UserListXIB: UITableViewCell {
    @IBOutlet weak var imgUser: AnimatableImageView!
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
