//
//  StoreContactVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 19/11/24.
//

import UIKit
import IBAnimatable

class StoreContactVC: UIViewController {

    @IBOutlet weak var messageView: AnimatableView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var phoneView: AnimatableView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var emailView: AnimatableView!
    var otherUserDetailsData : UserDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.otherUserDetailsData?.email?.isEmpty == true || self.otherUserDetailsData?.email == nil{
            self.emailView.isHidden = true
        }else{
            self.emailView.isHidden = false
            self.lblEmail.text = self.otherUserDetailsData?.email ?? ""
        }
        
        if self.otherUserDetailsData?.phone?.isEmpty == true || self.otherUserDetailsData?.phone == nil{
            self.phoneView.isHidden = true
            self.messageView.isHidden = true
        }else{
            self.phoneView.isHidden = false
            self.messageView.isHidden = false
            self.lblEmail.text = self.otherUserDetailsData?.phone ?? ""
        }
        
    }
    
    @IBAction func phoneOnPress(_ sender: UIButton) {
        CommunicationHelper.shared.callNumber(phoneNumber: self.lblPhone.text ?? "")
    }
    @IBAction func emailOnPress(_ sender: UIButton) {
        CommunicationHelper.shared.sendEmail(to: self.lblEmail.text ?? "", viewController: self)
    }
    @IBAction func dismissOnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sendMsgOnPress(_ sender: UIButton) {
        CommunicationHelper.shared.sendTextMessage(to: self.lblPhone.text ?? "", viewController: self)
    }
    
}
