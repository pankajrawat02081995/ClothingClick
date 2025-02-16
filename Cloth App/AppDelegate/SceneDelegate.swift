//
//  SceneDelegate.swift
//  Cloth App
//
//  Created by Apple on 14/12/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import UIKit
import FacebookCore
//import TwitterKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            
            let link = url.absoluteString
            print("link\(link)")
            if link.contains("post"){
                appDelegate.deeplinkurltype = "post"
                let pointsArr = link.split(separator: "/")
                let string2 = pointsArr.last
                appDelegate.deeplinkid = String(string2 ?? "")
                
            }else{
                appDelegate.deeplinkurltype = "user"
                let pointsArr = link.split(separator: "/")
                let string2 = pointsArr.last
                appDelegate.deeplinkid = String(string2 ?? "")
                
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deeplinknavigate"), object: nil)
        }
       
        guard let url = URLContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }
    
    
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            let link = url.absoluteString
            print("link\(link)")
            if link.starts(with: "https://apps.clothingclick.online/auth/instagram/callback") {
                if let code = URLComponents(string: link)?.queryItems?.first(where: { $0.name == "code" })?.value {
                    // You have the authorization code
                    print("Authorization Code: \(code)")
                    
                    // Exchange this code for an access token
                    exchangeCodeForAccessToken(code: code)
                }
            }else if link.contains("post"){
                appDelegate.deeplinkurltype = "post"
                let pointsArr = link.split(separator: "/")
                let string2 = pointsArr.last
                appDelegate.deeplinkid = String(string2 ?? "")
                
            }else if link.contains("profile"){
                appDelegate.deeplinkurltype = "user"
                let pointsArr = link.split(separator: "/")
                let string2 = pointsArr.last
                appDelegate.deeplinkid = String(string2 ?? "")
            }
            else{
                let options: [AnyHashable : Any] = [ UIApplication.OpenURLOptionsKey.annotation : url as Any, UIApplication.OpenURLOptionsKey.sourceApplication : url as Any, UIApplication.OpenURLOptionsKey.openInPlace : url]
                //                        TWTRTwitter.sharedInstance().application(UIApplication.shared, open: url, options: options)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deeplinknavigate"), object: nil)
            
            
            //            if let openURLContext = url{
            //                let url = openURLContext
            //                let options: [AnyHashable : Any] = [ UIApplication.OpenURLOptionsKey.annotation : openURLContext.options.annotation as Any, UIApplication.OpenURLOptionsKey.sourceApplication : openURLContext.options.sourceApplication as Any, UIApplication.OpenURLOptionsKey.openInPlace : openURLContext.options.openInPlace]
            //
            //            }
        }
        
    }
    
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let userActivity = connectionOptions.userActivities.first,
              userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return
        }
        
        // Check for specific URL components that you need.
        guard let path = components.path,
              let params = components.queryItems else {
            return
        }
        print("path = \(path)")
        
        if let albumName = params.first(where: { $0.name == "albumname" })?.value,
           let photoIndex = params.first(where: { $0.name == "index" })?.value {
            
            print("album = \(albumName)")
            print("photoIndex = \(photoIndex)")
        } else {
            print("Either album name or photo index missing")
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deeplinknavigate"), object: nil)
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deeplinknavigate"), object: nil)
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

extension SceneDelegate{
    func exchangeCodeForAccessToken(code: String) {
        let clientId = "547906594269337"
        let clientSecret = "d20a12476cd73267db30469b7055f6ff"
        let redirectUri = "https://apps.clothingclick.online/auth/instagram/callback"
        let tokenURL = "https://api.instagram.com/oauth/access_token"
        
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        
        // Set up the POST body parameters
        let postString = "client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=authorization_code&redirect_uri=\(redirectUri)&code=\(code)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let accessToken = json["access_token"] as? String {
                        print("Access Token: \(accessToken)")
                        // Use the access token to fetch user details
                        self.fetchInstagramUserDetails(accessToken: accessToken)
                    } else {
                        print("Failed to extract access token.")
                    }
                } catch {
                    print("Error parsing response: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func fetchInstagramUserDetails(accessToken: String) {
        let userDetailsURL = "https://graph.instagram.com/me?fields=id,username,account_type&access_token=\(accessToken)"
        
        let request = URLRequest(url: URL(string: userDetailsURL)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("User Details: \(json)")
                        if let userID = json["username"] as? String {
                            appDelegate.userDetails?.instagram_id = userID
                        }
                    }
                } catch {
                    print("Error parsing user details: \(error)")
                }
            }
        }
        task.resume()
    }
    
}
