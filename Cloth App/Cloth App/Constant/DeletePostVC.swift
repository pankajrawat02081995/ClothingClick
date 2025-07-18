//
//  DeletePostVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 30/09/24.
//

import Foundation
import UIKit

class DeletePostVC:UIViewController{
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDelete: CustomButton!
    @IBOutlet weak var btnCancel: CustomButton!
    var deleteOnTap : (()->Void)?
    var cancelOnTap : (()->Void)?
    var titleMain : String?
    var cancelTitle : String?
    var subTitle : String?
    var deleteTitle : String?
    var isCancelHide : Bool?
    var deleteBgColor : UIColor?
    var imgMain : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCancel.isHidden = self.isCancelHide ?? false
        self.btnCancel.setTitle(self.cancelTitle ?? "Cancel", for: .normal)
        self.btnDelete.backgroundColor = self.deleteBgColor ??  UIColor()
        self.lblTitle.text = self.titleMain ?? ""
        self.lblSubTitle.text = self.subTitle ?? ""
        self.btnDelete.setTitle(self.deleteTitle, for: .normal)
        self.img.image = self.imgMain ?? UIImage()
    }
    
    @IBAction func cancelOnPress(_ sender: UIButton) {
        self.dismiss(animated: true){
            self.cancelOnTap?()
        }
    }
    @IBAction func deleteOnPress(_ sender: UIButton) {
        self.dismiss(animated: true){
            self.deleteOnTap?()
        }
    }
}
