//
//  CongratulationsViewController.swift
//  ClothApp
//
//  Created by Apple on 18/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import GoogleMobileAds



class CongratulationsViewController: BaseViewController {
    
  

    @IBOutlet weak var lblCoinCount: UILabel!
    @IBOutlet weak var btnSharePost: CustomButton!
    @IBOutlet weak var btnPostAnotherTtem: CustomButton!
    @IBOutlet weak var btnDone: CustomButton!
    @IBOutlet weak var viewBanner: GADBannerView!
    @IBOutlet weak var btnAdPlacement: UIButton!
    var sendproductImage = [UIImage]()
    var postId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.userDetails?.is_premium_activated == 0 {
            self.viewBanner.isHidden = false
            self.viewBanner.adUnitID = "ca-app-pub-7377141818202598/7496609505"
            self.viewBanner.rootViewController = self
            self.viewBanner.load(GADRequest())
            self.viewBanner.delegate = self
        }
        else {
            self.viewBanner.isHidden = true
        }
        
        let image = UIImage(named: "share-ic")?.imageWithColor(color1: .white)
        self.btnSharePost.setImage(image, for: .normal)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.viewBanner.addSubview(bannerView)
        self.viewBanner.leftAnchor.constraint(equalTo: bannerView.leftAnchor).isActive = true
        self.viewBanner.rightAnchor.constraint(equalTo: bannerView.rightAnchor).isActive = true
        self.viewBanner.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor).isActive = true
        self.viewBanner.topAnchor.constraint(equalTo: bannerView.topAnchor).isActive = true
       }
    
    @IBAction func btnPostAnotherTtem_Clicked(_ button: UIButton) {
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        self.navigateToHomeScreen(selIndex: 2)
    }
    
    @IBAction func btnDone_Clicked(_ button: UIButton) {
        self.navigateToHomeScreen()
    }
    
    @IBAction func btnAdPlacement_Clicked(_ button: UIButton) {
    }
    
    @IBAction func btnSharePost_Clicked(_ button: UIButton) {
//        let url = URL.init(string: APP_SHARE_ITUNES_URL)!
//        let objectsToShare = ["Hi,\n\nCheck out LCCC, the social app for South Asian women. I've just just joined the community and thought you would like it too!\n\nDownload now and join the sisterhood.\n", url] as [Any]
//        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        //activityVC.popoverPresentationController?.sourceView = sender
//        self.present(activityVC, animated: true, completion: nil)
        let url = URL.init(string: "\(SERVER_URL)share/post/\(self.postId)")!
        let img = UIImage(named: "wel_logo")
                   // let messageStr = "Ketan SO"
                    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [img!, url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
                
    }
}

extension CongratulationsViewController: GADBannerViewDelegate {
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Fail to receive ads")
        print(error)
    }
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
      // Add banner to view and add constraints as above.
      addBannerViewToView(bannerView)
    }
}
