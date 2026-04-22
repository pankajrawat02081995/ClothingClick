//
//  LoginViewController.swift
//  Demo
//
//  Created by Hardy on 3/2/19.
//  Copyright © 2019 Sagar Nandha. All rights reserved.
//

import UIKit

class PhotoViewController: BaseViewController, EFImageViewZoomDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imageViewZoom: EFImageViewZoom!
    
    var imageUrl = ""
    var descriptionText = ""
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDescription.text = "" //self.descriptionText
        self.imageViewZoom._delegate = self
        
        if let url = URL(string: imageUrl) {
            if imageUrl.contains(".gif") {
                self.imageViewZoom.imageView.setGifFromURL(url, manager: gifManager, loopCount: -1, showLoader: true)
            }
            else {
                let imgPhoto = UIImageView()
//                imgPhoto.kf.setImage(with: url, placeholder: PlaceHolderImage, options: nil, progressBlock: nil) { (image, error, type, url) in
//                    if image != nil {
//                        self.image = image!
//                        self.imageViewZoom.image = image!
//                    }
//                }
                imgPhoto.kf.setImage(with: url, placeholder: PlaceHolderImage, options: nil) { result in
                    switch result {
                    case .success(let value):
                        self.image = value.image
                        self.imageViewZoom.image = value.image
                    case .failure(let error):
                        print("Download image failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func btnShare_Clicked(_ sender: Any) {
//        if self.image != nil {
//            let activityVC = UIActivityViewController(activityItems: [self.image], applicationActivities: nil)
//            self.present(activityVC, animated: true, completion: nil)
//        }
//    }
    
    func showHelperCircle() {
        let center = CGPoint(x: view.bounds.width * 0.5, y: 100)
        let small = CGSize(width: 30, height: 30)
        let circle = UIView(frame: CGRect(origin: center, size: small))
        circle.layer.cornerRadius = circle.frame.width/2
        circle.backgroundColor = UIColor.white
        circle.layer.shadowOpacity = 0.8
        circle.layer.shadowOffset = CGSize()
        view.addSubview(circle)
        
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [],
            animations: {
                circle.frame.origin.y += 200
                circle.layer.opacity = 0
        }, completion: { _ in
                circle.removeFromSuperview()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
