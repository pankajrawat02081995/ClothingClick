//
//  DiscoveHeaderCellXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 20/06/24.
//

import UIKit

class DiscoveHeaderCellXIB: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnSeeMore: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
