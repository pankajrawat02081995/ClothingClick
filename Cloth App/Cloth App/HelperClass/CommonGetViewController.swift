//
//  CommonGetViewController.swift
//  AnythingAuto
//
//  Created by User on 19/02/24.
//

import Foundation
import UIKit

enum StoryboardName: String {
    case Main
    case Dashboard
    case Auth
    case Sell
    case Landing
    case Store
    case Setting
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: .main)
    }
    
    func viewController<T: UIViewController>() -> T {
        let storyboardID = T.storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("Unable to instantiate view controller with identifier '\(storyboardID)' from storyboard '\(rawValue)'.")
        }
        return scene
    }
}

extension UIViewController {
    class var storyboardID: String {
        return String(describing: self)
    }
    
    static func instantiate(fromStoryboard storyboard: StoryboardName) -> Self {
        guard let viewController = storyboard.instance.instantiateViewController(withIdentifier: storyboardID) as? Self else {
            fatalError("Unable to instantiate view controller with identifier '\(storyboardID)' from storyboard '\(storyboard.rawValue)'.")
        }
        return viewController
    }
}
