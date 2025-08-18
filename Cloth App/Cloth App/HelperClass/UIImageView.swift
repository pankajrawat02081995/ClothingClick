//
//  UIImageView.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 05/03/25.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    
    func preferredContentMode() -> UIView.ContentMode {
        guard let img = self.image else { return .scaleAspectFit }
        
        if img.size.width > img.size.height {
            // Landscape image → fit inside view
            return .scaleAspectFit
        } else if img.size.width < img.size.height {
            // Portrait image → fill the view
            return .scaleAspectFill
        } else {
            // Square image → usually fill looks better
            return .scaleAspectFill
        }
    }
    
    func setImageFast(with urlString: String?, placeholder: UIImage? = PlaceHolderImage) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        // Show activity indicator while loading
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        self.sd_setImage(
            with: url,
            placeholderImage: placeholder,
            options: [
                .highPriority,             // Ensures faster loading
                .retryFailed,              // Retries failed requests
                .scaleDownLargeImages,     // Reduces image size before caching
                .continueInBackground,     // Loads even when the app is in the background
                .avoidAutoSetImage         // Loads the image but doesn’t set it immediately
            ]) { [weak self] (image, error, cacheType, url) in
                guard let self = self, let image = image else {
                    self?.image = placeholder // Fallback to placeholder if loading fails
                    return
                }
                
                // Use fade-in animation only if the image is newly downloaded
                if cacheType == .none {
                    UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        self.image = image
                    }, completion: nil)
                } else {
                    self.image = image
                }
            }
    }
}


import UIKit
import SDWebImage

extension UIImageView {
    func setProfileImage(from urlString: String?, placeholderName name: String) {
        if let urlString = urlString, let url = URL(string: urlString), !urlString.isEmpty {
            self.sd_setImage(with: url, placeholderImage: nil, options: [.retryFailed, .continueInBackground]) { image, error, _, _ in
                if image == nil {
                    self.setInitialsPlaceholder(name: name)
                }
            }
        } else {
            self.setInitialsPlaceholder(name: name)
        }
    }

    private func setInitialsPlaceholder(name: String) {
        let initial = String(name.prefix(1)).uppercased()
        let label = UILabel()
        label.text = initial
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        label.font = UIFont.systemFont(ofSize: self.bounds.height / 2, weight: .bold)
        label.frame = self.bounds
        label.clipsToBounds = true

        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        label.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.image = img
    }
}
