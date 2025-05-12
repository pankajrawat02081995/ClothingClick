//
//  UIVIewController.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 28/05/24.
//

import Foundation
import AVFoundation
import AVKit

extension UIViewController{
    
    func popToViewController<T: UIViewController>(ofType type: T.Type, animated: Bool) {
        guard let viewControllers = navigationController?.viewControllers else {
            return
        }

        for viewController in viewControllers {
            if viewController is T {
                navigationController?.popToViewController(viewController, animated: animated)
                break
            }
        }
    }

    
//    func share(userName: String) {
//        let text = "I'm on Clothing Click as \(userName). Install the app to follow my posts and discover great deals on clothing in your area. Download App Now: itms-apps://itunes.apple.com/app/id1605715607"
//        
//        guard let url = URL(string: APP_SHARE_ITUNES_URL) else {
//            print("Invalid share URL")
//            return
//        }
//
//        let activityViewController = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
//
//        // Excluding unnecessary activity types while allowing copy to pasteboard
//        activityViewController.excludedActivityTypes = [
//            .print,
//            .postToWeibo,
//            .addToReadingList,
//            .postToVimeo
//        ]
//
//        // Completion handler to log actions
//        activityViewController.completionWithItemsHandler = { activity, success, items, error in
//            if let error = error {
//                print("Error during sharing: \(error.localizedDescription)")
//            } else if success {
//                print("Sharing successful via \(activity?.rawValue ?? "Unknown")")
//            }
//        }
//
//        self.present(activityViewController, animated: true, completion: nil)
//    }
    
    func presentCustomPopup() {
        let popup = RateAppPopup(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        popup.center = self.view.center
        popup.layer.cornerRadius = 12
        popup.clipsToBounds = true
        popup.backgroundColor = .white

        // Optional fade-in animation
        popup.alpha = 0
        self.view.addSubview(popup)
        UIView.animate(withDuration: 0.3) {
            popup.alpha = 1
        }

        // Example dismiss action
//        popup.rateNowTapped.addTarget(self, action: #selector(dismissPopup(_:)), for: .touchUpInside)
    }

    @objc func dismissPopup(_ sender: UIButton) {
        if let popup = sender.superview?.superview { // Adjust hierarchy if needed
            UIView.animate(withDuration: 0.3, animations: {
                popup.alpha = 0
            }) { _ in
                popup.removeFromSuperview()
            }
        }
    }




    func share(userName: String) {
        let appSchemeURL = URL(string: "clothingclick://profile/\(userName)")!
        let appStoreURL = URL(string: "https://apps.apple.com/us/app/clothing-click-second-hand/id1605715607")!
        let universalLink = "https://app.clothingclick.ca/api/v1/profile/\(userName)"

        let text = "I'm on Clothing Click as \(userName). Install the app to follow my posts and discover great deals on clothing in your area. Join me here: \(universalLink)"

        let activityViewController = UIActivityViewController(activityItems: [text, URL(string: universalLink)!], applicationActivities: nil)

        activityViewController.excludedActivityTypes = [
            .print, .postToWeibo, .addToReadingList, .postToVimeo
        ]

        // Present the activity view controller first
        activityViewController.modalPresentationStyle = .overCurrentContext
        self.present(activityViewController, animated: true)
    }
    
    func playVideo(url: URL) {
          // Create an AVPlayer
          let player = AVPlayer(url: url)
          
          // Create an AVPlayerViewController and pass it a reference to the player.
          let playerViewController = AVPlayerViewController()
          playerViewController.player = player
          
          // Present the AVPlayerViewController
          present(playerViewController, animated: true) {
              // Start playback automatically
              player.play()
          }
      }
    
    func pushViewController(vc:UIViewController){
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
}

