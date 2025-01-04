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

    
    func share(userName:String){
        let text = "I'm on Clothing Click as \(userName). Install the app to follow my posts and discover great deals on clothing in your area. Download App Now: itms-apps://itunes.apple.com/app/id1605715607"
        let url = URL.init(string: APP_SHARE_ITUNES_URL)!
        //let img = UIImage(named: "wel_logo")
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [text, url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
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

