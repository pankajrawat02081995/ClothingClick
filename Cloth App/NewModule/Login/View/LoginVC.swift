//
//  LoginVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 26/05/24.
//

import UIKit


class LoginVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func dismissOnPress(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func fbOnTap(_ sender: UIButton) {
        self.loginWithFacebook()
        
    }
    
    @IBAction func googleOnTap(_ sender: UIButton) {
//        self.loginWithGoogle { user in
//            if let userId = user?.userID {
//                self.socialId = userId
//            }
//            if let firstName = user?.profile?.givenName {
//                self.firstName = firstName
//            }
//            if let lastName = user?.profile?.familyName {
//                self.lastName = lastName
//            }
//            if let email = user?.profile?.email {
//                self.emailId = email
//            }
//            self.socialLogin()
//            
//        }
    }
    
    @IBAction func appleOnTap(_ sender: UIButton) {
    }
    
    @IBAction func emailOnTap(_ sender: UIButton) {
        let vc = LoginViewController.instantiate(fromStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func troubleOnTap(_ sender: UIButton) {
    }
}
