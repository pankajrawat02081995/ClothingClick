//
//  ProfilePageTbCell.swift
//  SearchVC
//
//  Created by Pankaj Rawat on 03/09/24.
//

import UIKit
import IBAnimatable

class ProfilePageTbCell: UITableViewCell {
    
    
    @IBOutlet weak var btnOpenTime: UIButton!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var lblPostsCount: UILabel!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnFollow: AnimatableButton!
    @IBOutlet weak var viewContact: AnimatableView!
    @IBOutlet weak var viewDirections: AnimatableView!
    @IBOutlet weak var lblWebsite: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var lblOpenTime: UILabel!
    @IBOutlet weak var lblDese: UILabel!
    @IBOutlet weak var lblNameLater: UILabel!
    @IBOutlet weak var viewOne: UIView!
    
    @IBOutlet weak var btnDirection: UIButton!
    
    
    @IBOutlet weak var viewTwo: UIView!
    
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblStoreUserName: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    
    var otherUserDetailsData : UserDetailsModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PostImageXIB", bundle: nil), forCellWithReuseIdentifier: "PostImageXIB")
        
    }
    
    func setData(otherUserDetailsData:UserDetailsModel) {
        self.otherUserDetailsData = otherUserDetailsData
        self.collectionView.reloadData()
        
        //Show Store timings
        let timings = otherUserDetailsData.storeDetail?.timings ?? [:]
        lblOpenTime.text = "Open Until \(GetData.shared.getTodayCloseTime(for: timings) ?? "")"
        
        if let url = self.otherUserDetailsData?.photo {
            self.lblNameLater.isHidden = true
            self.imgStore.setImageFast(with: url)
        }else{
            self.imgStore.backgroundColor = .black
            self.lblNameLater.isHidden = false
            self.lblNameLater.text = self.otherUserDetailsData?.name?.first?.description ?? ""
        }
        
        if let postCount = self.otherUserDetailsData?.totalPosts {
            self.lblPostsCount.text = "\(postCount)"
        }
        if let followerCount = self.otherUserDetailsData?.totalFollowers {
            self.lblFollowerCount.text = "\(followerCount)"
        }
        if let followingCount = self.otherUserDetailsData?.totalFollowings {
            self.lblFollowingCount.text = "\(followingCount)"
        }
        if let name = self.otherUserDetailsData?.name {
            self.lblStoreName.text = name
        }
        if let name = self.otherUserDetailsData?.username {
            self.lblStoreUserName.text = "@\(name)"
        }
        
        if let website = self.otherUserDetailsData?.website {
            self.lblWebsite.setTitle(website, for: .normal)
        }
        
        if let usserDetails = self.otherUserDetailsData?.bio {
            self.lblDese.text = usserDetails
        }
        
        if let ratingCount = self.otherUserDetailsData?.avg_rating{
            self.lblRate.text = "\(Double(ratingCount)) (\(self.otherUserDetailsData?.total_reviews ?? 0) Reviews)"
        }
//        if let contact = self.otherUserDetailsData?.phone{
//            self.viewContact.isHidden = false
//        }else{
//            self.viewContact.isHidden = true
//        }
        
//        if let location = self.otherUserDetailsData?.locations?.count ,  location == 0{
//            self.viewDirections.isHidden = true
//        }else{
//            self.viewDirections.isHidden = false
//        }
        
        if self.otherUserDetailsData?.is_requested == 1 {
            self.btnFollow.setTitleColor(.customWhite, for: .normal)
            self.btnFollow.setTitle("Requested", for: .normal)
            self.btnFollow.borderWidth = 1
            self.btnFollow.borderColor = .customBlack
            self.btnFollow.backgroundColor = .customBlack
        }
        else {
            if self.otherUserDetailsData?.is_following == 0 {
                self.btnFollow.setTitleColor(.customWhite, for: .normal)
                self.btnFollow.setTitle("Follow", for: .normal)
                self.btnFollow.borderWidth = 0
                self.btnFollow.backgroundColor = UIColor.customBlack
            }
            else{
                self.btnFollow.setTitleColor(.white, for: .normal)
                self.btnFollow.setTitle("Following", for: .normal)
                self.btnFollow.borderWidth = 1
                self.btnFollow.borderColor = .customBlack
                self.btnFollow.backgroundColor = .customBlack
            }
        }
    }
}

extension ProfilePageTbCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // Example number of items; update this based on your data
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageXIB", for: indexPath) as? PostImageXIB else {
            return UICollectionViewCell()
        }
        
        cell.imgPost.setImageFast(with: self.otherUserDetailsData?.cover_image ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsInRow: CGFloat = 2 // Two items per row
        let totalSpacing = (numberOfItemsInRow - 1) * 10 // Assuming a 10-point spacing
        let itemWidth = (collectionView.frame.width - totalSpacing) / numberOfItemsInRow
        
        // Return size for the item
        return CGSize(width: itemWidth, height: itemWidth) // Adjust height if needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between items in the same row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Adjust insets if necessary
    }
}
