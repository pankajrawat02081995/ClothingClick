//
//  ChatListXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 20/05/24.
//

import UIKit
import IBAnimatable
class ChatListXIB: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: AnimatableImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
