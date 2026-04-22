//
//  LoginVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 26/05/24.
//

import UIKit


class LoginVC: BaseViewController {

    var pushView : ((UIViewController)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissOnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func fbOnTap(_ sender: UIButton) {
            self.loginWithFacebook()
    }
    
    @IBAction func googleOnTap(_ sender: UIButton) {
        loginWithGoogle { user in
            if let user = user {
                debugPrint(user)
                // Perform any post-login actions here
                self.dismiss(animated: true, completion: nil) // Dismiss after successful login
            } else {
                debugPrint("Google login failed or was canceled.")
            }
        }
    }
    
    @IBAction func appleOnTap(_ sender: UIButton) {
        self.loginWithApple()
    }
    
    @IBAction func emailOnTap(_ sender: UIButton) {
        let vc = LoginViewController.instantiate(fromStoryboard: .Auth)
        self.dismiss(animated: true){
            self.pushView?(vc)
        }
    }
    
    @IBAction func troubleOnTap(_ sender: UIButton) {
        let viewController = TroubleLoginViewController.instantiate(fromStoryboard: .Main)
        self.dismiss(animated: true){
            self.pushView?(viewController)
        }
    }
}
