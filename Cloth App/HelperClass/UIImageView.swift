//
//  UIImageView.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 05/03/25.
//

import UIKit
import SDWebImage

import UIKit
import SDWebImage

extension UIImageView {
    
    /// Cancel previous SDWebImage download when cell reused
    func cancelImageLoadIfAny() {
        self.sd_cancelCurrentImageLoad()
    }
    
    func preferredContentMode() -> UIView.ContentMode {
        guard let img = self.image else { return .scaleAspectFit }
        
        if img.size.width > img.size.height {
            return .scaleAspectFit      // Landscape
        } else if img.size.width < img.size.height {
            return .scaleAspectFill     // Portrait
        } else {
            return .scaleAspectFill     // Square
        }
    }
    
    func setImageFast(with urlString: String?, placeholder: UIImage? = PlaceHolderImage) {
        
        // Cancel previous image request (PREVENT MEMORY LEAKS)
        self.sd_cancelCurrentImageLoad()
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        // SDWebImage loader
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        self.sd_setImage(
            with: url,
            placeholderImage: placeholder,
            options: [
                .highPriority,
                .retryFailed,
                .scaleDownLargeImages,
                .continueInBackground,
                .avoidAutoSetImage
            ]) { [weak self] (image, error, cacheType, url) in
                guard let self = self else { return }
                
                let finalImage = image ?? placeholder
                
                // Smooth fade only if NOT cached
                if cacheType == .none {
                    UIView.transition(
                        with: self,
                        duration: 0.25,
                        options: .transitionCrossDissolve,
                        animations: { self.image = finalImage },
                        completion: nil
                    )
                } else {
                    self.image = finalImage
                }
        }
    }
}



import UIKit
import SDWebImage

extension UIImageView {
    func setProfileImage(from urlString: String?, placeholderName name: String) {
        // Always set content mode to aspect fit
        self.contentMode = .scaleAspectFit
        
        if let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) {
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
