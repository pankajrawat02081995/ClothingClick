//
//  LoaderView.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 21/04/25.
//

import UIKit
import KRProgressHUD

final class LoaderManager {
    
    static let shared = LoaderManager()
    private var whiteOverlayView: UIView?

    private init() {}

    // MARK: - Show Loader
    func show(on view: UIView? = nil, topPadding: CGFloat = 50) {
        guard let targetView = view ?? getKeyWindow() else {
            return
        }

        // Avoid adding multiple overlays
        if whiteOverlayView == nil {
            let whiteView = UIView()
            whiteView.backgroundColor = .white
            whiteView.translatesAutoresizingMaskIntoConstraints = false
            targetView.addSubview(whiteView)

            NSLayoutConstraint.activate([
                whiteView.topAnchor.constraint(equalTo: targetView.topAnchor, constant: topPadding),
                whiteView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor),
                whiteView.trailingAnchor.constraint(equalTo: targetView.trailingAnchor),
                whiteView.bottomAnchor.constraint(equalTo: targetView.bottomAnchor)
            ])

            whiteOverlayView = whiteView
        }

        KRProgressHUD.show()
    }

    // MARK: - Hide Loader
    func hide() {
        KRProgressHUD.dismiss()
        whiteOverlayView?.removeFromSuperview()
        whiteOverlayView = nil
    }

    // MARK: - Get Key Window (iOS 13+ Safe)
    private func getKeyWindow() -> UIWindow? {
        // Get the connected scenes
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
