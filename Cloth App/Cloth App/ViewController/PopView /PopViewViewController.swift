//
//  PopViewViewController.swift
//  Cloth App
//
//  Created by Hardik nandha on 12/01/23.
//

import UIKit

class PopViewViewController: UIViewController {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnShear: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var imgCloth: UIImageView!
    @IBOutlet weak var btnClaose: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnCLose_Clicked(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnShear_Clicked(_ button: UIButton) {
        let text = "I'm on Clothing Click as \(appDelegate.userDetails?.username ?? ""). Install the app to follow my posts and discover great deals on clothing in your area. Download App Now: itms-apps://itunes.apple.com/app/id1605715607"
        let url = URL.init(string: APP_SHARE_ITUNES_URL)!
        //let img = UIImage(named: "wel_logo")
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [text, url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
