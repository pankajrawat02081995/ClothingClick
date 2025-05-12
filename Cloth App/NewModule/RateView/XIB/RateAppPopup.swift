//
//  RateAppPopup.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 11/05/25.
//

import UIKit
import StoreKit

class RateAppPopup: UIView {
    
    
    // MARK: - Actions
    @IBAction func rateNowTapped(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasRated")
        openAppStoreForRating()
        self.removeFromSuperview()
    }

    @IBAction func laterTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }

    @IBAction func noThanksTapped(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasRated")
        self.removeFromSuperview()
    }

    private func openAppStoreForRating() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func show(in parent: UIView) {
        parent.addSubview(self)
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }

        private func commonInit() {
            Bundle.main.loadNibNamed("RateAppPopup", owner: self, options: nil)
            guard let contentView = self.subviews.first else { return }
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(contentView)
        }
}

