//
//  LoginViewController.swift
//  Demo
//
//  Created by Hardy on 3/2/19.
//  Copyright © 2019 Sagar Nandha. All rights reserved.
//

import UIKit
import AVKit

class PhotosViewController: BaseViewController, EFImageViewZoomDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imageCV: UICollectionView!
    var imagesList = [ImagesVideoModel]()
    var visibleIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDescription.text = ""
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.imageCV.scrollToItem(at: IndexPath.init(item: self.visibleIndex, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //    @IBAction func btnShare_Clicked(_ sender: Any) {
    //        let indexPath = IndexPath.init(item: self.visibleIndex, section: 0)
    //        if let cell = imageCV.cellForItem(at: indexPath) as? PhotoCell {
    //            if let image = cell.imgGallery.image {
    //                let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    //                self.present(activityVC, animated: true, completion: nil)
    //            }
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = self.imageCV.contentOffset
        visibleRect.size = self.imageCV.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.imageCV.indexPathForItem(at: visiblePoint) else { return }
        
        self.visibleIndex = indexPath.item
        self.lblDescription.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.imageCV.bounds.width, height: self.imageCV.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        cell.imgPlay.isHidden = true
        cell.btnPlay.isHidden = true
        cell.imgGallery._delegate = self
        cell.btnPlay.addTarget(self, action: #selector(btnPlay_Clicked(_:)), for: .touchUpInside)
        if self.imagesList[indexPath.item].type == "video" {
            if let url = self.imagesList[indexPath.item].video{
                if let videourl = URL.init(string: url){
                    cell.imgPlay.isHidden = false
                    cell.btnPlay.isHidden = false
                    self.getThumbnailImageFromVideoUrl(url:videourl) { (thumbImage) in
                        cell.imgGallery.image = thumbImage
                    }
                }
            }else{
                cell.imgPlay.isHidden = false
                cell.btnPlay.isHidden = false
                if let image = self.imagesList[indexPath.item].image1  {
                    cell.imgGallery.image = image
                }
            }
        }
        else {
            if let imageUrl = self.imagesList[indexPath.item].image{
                if let url = URL(string: imageUrl) {
                    if imageUrl.contains(".gif") {
                        cell.imgGallery.imageView.setGifFromURL(url, manager: gifManager, loopCount: -1, showLoader: true)
                    }
                    else {
                        let imgPhoto = UIImageView()
//                        imgPhoto.kf.setImage(with: url, placeholder: PlaceHolderImage, options: nil, progressBlock: nil) { (image, error, type, url) in
//                            if image != nil {
//                                cell.imgGallery.image = image!
//                            }
//                        }
                        imgPhoto.kf.setImage(with: url, placeholder: PlaceHolderImage, options: nil) { result in
                            switch result {
                            case .success(let value):
//                                self.image = value.image
                                cell.imgGallery.image = value.image
                            case .failure(let error):
                                print("Download image failed: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            else{
                if let image = self.imagesList[indexPath.item].image1  {
                    
                    cell.imgGallery.image = image
                }
            }
        }
        return cell
    }
    @objc func btnPlay_Clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.imageCV)
        if let indexPath = self.imageCV.indexPathForItem(at: poston) {
            if self.imagesList[indexPath.item].type == "video" {
                if let videoUrl = self.imagesList[indexPath.item].video {
                    let videoURL = URL(string: videoUrl)
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
            }
        }
    }
}

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imgGallery: EFImageViewZoom!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
}
