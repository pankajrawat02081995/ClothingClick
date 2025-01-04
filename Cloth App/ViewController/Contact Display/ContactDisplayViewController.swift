//
//  ContactDisplayViewController.swift
//  ClothApp
//
//  Created by Apple on 12/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class ContactDisplayViewController: BaseViewController {

    @IBOutlet weak var btnContactViewHide: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblCallTitle: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewLine2: UIView!
    @IBOutlet weak var constTopForviewLine2: NSLayoutConstraint!
    @IBOutlet weak var constTopForviewLine: NSLayoutConstraint!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    var phoneNo =  ""
    var email = ""
    
    var isEmailShow = false
    var isPhoneShow = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "close_ic_white")?.imageWithColor(color1: UIColor.init(hex: "000000"))
        self.btnClose.setImage(image, for: .normal)
        
        if self.isEmailShow && self.isPhoneShow {
            self.lblPhoneNo.text = self.phoneNo
            self.lblEmail.text = self.email
        }
        else {
//            if self.isEmailShow || self.isPhoneShow {
                if self.isPhoneShow {
                    self.lblEmailTitle.isHidden = true
                    self.lblEmail.isHidden = true
                    self.viewLine.isHidden = true
                    self.viewLine2.isHidden = true
                    self.constTopForviewLine.constant = -80
                    self.lblPhoneNo.text = self.phoneNo
                    self.lblCallTitle.isHidden = false
                    self.lblPhoneNo.isHidden = false
                    
                }
                else {
                    self.constTopForviewLine.constant = -85
                    self.viewLine.isHidden = true
                    self.viewLine2.isHidden = false
                    self.lblEmail.text = self.email
                    self.lblCallTitle.isHidden = true
                    self.lblPhoneNo.isHidden = true
                    self.lblEmailTitle.isHidden = false
                    self.lblEmail.isHidden = false
                    
                }
//            }
        }
    }
    
    @IBAction func btnClose_Clicked(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnContact_Clicked(_ button: UIButton) {
        UIAlertController().alertViewWithTitleAndMessage(self, message: "Contact Copied")
        UIPasteboard.general.string = self.phoneNo
    }
    @IBAction func btnEmail_Clicked(_ button: UIButton) {
        UIAlertController().alertViewWithTitleAndMessage(self, message: "Email Copied")
        UIPasteboard.general.string = self.email
    }
    
    @IBAction func btnContactViewHide_Clicked(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
