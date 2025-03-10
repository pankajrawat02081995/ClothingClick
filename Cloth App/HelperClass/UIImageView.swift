//
//  UIImageView.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 05/03/25.
//

import UIKit
import SDWebImage

extension UIImageView {
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


