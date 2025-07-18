//
//  GoogleLoginIntegration.swift
//  ConsignItAway
//
//  Created by appsdeveloper Developer on 21/03/22.
//

import Foundation
import UIKit
import GoogleSignIn

class GoogleLoginIntegration: NSObject {
    
    static let shared = GoogleLoginIntegration()
    var closureDidGetResultDetails: ((GIDSignInResult) -> ())?
    var closureDidGetUserDetails: ((GIDGoogleUser) -> ())?
    private var presentedVC: UIViewController?
    
    func signInWith(presentingVC: UIViewController) {
        self.presentedVC = presentingVC
        
        let config = GIDConfiguration(clientID: "116352694559-g2pj1ce08gid6chb7dtk8c80q1om1skd.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signOut()

        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC){ user, error in
            if let err = error {
                print(error?.localizedDescription)
            } else {
                self.closureDidGetUserDetails?(user!.user)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print(error.localizedDescription)
        } else {
            self.closureDidGetUserDetails?(user!)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        presentedVC?.dismiss(animated: true, completion: nil)
    }
}
