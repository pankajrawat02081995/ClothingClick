//
//  StoreVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 01/09/24.
//

import UIKit

class StoreVC: UIViewController {
    
    
    @IBOutlet weak var itemCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var itemClcView: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var btnFollow: UIButton!
    
    
    @IBOutlet weak var viewContact: UIView!
    
    @IBOutlet weak var viewDirections: UIView!
    
    
    @IBOutlet weak var btnShare: UIButton!
    
    
    @IBOutlet weak var viewOne: UIView!
    
    
    
    @IBOutlet weak var viewTwo: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnFollow.layer.cornerRadius = 5
        self.btnFollow.layer.borderColor = UIColor.black.cgColor
        self.btnFollow.layer.borderWidth = 1
        
        self.viewContact.layer.cornerRadius = 5
        self.viewContact.layer.borderColor = UIColor.lightGray.cgColor
        self.viewContact.layer.borderWidth = 1
        
        self.viewDirections.layer.cornerRadius = 5
        self.viewDirections.layer.borderColor = UIColor.lightGray.cgColor
        self.viewDirections.layer.borderWidth = 1
        
        self.btnShare.layer.cornerRadius = 5
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        self.itemCollectionHeight.constant = contentHeight
    }
    
    func getRandomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    @IBAction func btnSellingClicked(_ sender: UIButton) {
        self.viewOne.backgroundColor = .black
        self.viewTwo.backgroundColor = .lightGray
    }
    
    
    
    @IBAction func btnSoldClicked(_ sender: UIButton) {
        self.viewTwo.backgroundColor = .black
        self.viewOne.backgroundColor = .lightGray
    }
    
    @IBAction func sechudledOnPress(_ sender: UIButton) {
    }
    
    
}


class ItemsClcCell: UICollectionViewCell {
    
    @IBOutlet weak var imgItem: UIImageView!
    
}


class TopClCCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
}

extension StoreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.itemClcView {
            return 10
        } else {
            return 5
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.itemClcView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsClcCell", for: indexPath) as! ItemsClcCell
            cell.imgItem.layer.borderColor = UIColor.darkGray.cgColor
            cell.imgItem.layer.borderWidth = 1.0
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopClCCell", for: indexPath) as! TopClCCell
            cell.img.backgroundColor = self.getRandomColor()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.itemClcView {
            return CGSize.init(width: self.itemClcView.bounds.width/2 - 6, height: 230)
        } else {
            return CGSize.init(width: self.collectionView.bounds.width, height: 155)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        self.pageControl.currentPage = Int(pageIndex)
    }
    
}
