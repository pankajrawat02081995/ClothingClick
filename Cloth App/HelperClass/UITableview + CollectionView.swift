//
//  UITableview + CollectionView.swift
//  AnythingAuto
//
//  Created by apple on 20/02/24.
//

import Foundation
import UIKit

extension UITableView{
    
    func registerCell(nib:UINib,identifier:String){
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
//    func noDataLable(indexPath:IndexPath) -> UITableViewCell{
//        let cell = self.dequeueReusableCell(withIdentifier: NoDataXIB.identifier, for: indexPath)
//        return cell
//    }
    
    //MARK:- Set Table View Background label
    func setBackGroundLabel(yPosition: CGFloat? = nil, count: Int,text:String?="No Data Found"){
        if count > 0 {
            self.backgroundView = nil
        }else{
            let y = (yPosition != nil ? yPosition : self.frame.height/2-40) ?? self.frame.height/2-40
            
            let backLabel = UILabel.init(frame: CGRect(x: 0.0, y: y, width: self.frame.width, height: 60))
            backLabel.text = text
            backLabel.numberOfLines = 0
            if #available(iOS 12.0, *) {
                if traitCollection.userInterfaceStyle == .dark{
                    backLabel.textColor = UIColor.white
                }else{
                    backLabel.textColor = UIColor.black
                }
            } else {
                // Fallback on earlier versions
                backLabel.textColor = UIColor.black
            }
            backLabel.textAlignment = .center
            self.backgroundView = backLabel
        }
    }
}

extension UICollectionView{
    
    func registerCell(nib:UINib,identifier:String){
           self.register(nib, forCellWithReuseIdentifier: identifier)
       }

    
    //MARK:- Set Table View Background label
    func setBackGroundLabel(msg:String = "No Data Found",yPosition: CGFloat? = nil, count: Int){
        if count > 0 {
            self.backgroundView = nil
        }else{
            let y = (yPosition != nil ? yPosition : self.frame.height/2-40) ?? self.frame.height/2-40
            
            let backLabel = UILabel.init(frame: CGRect(x: 0.0, y: y, width: self.frame.width, height: 60))
            backLabel.text = msg
            backLabel.numberOfLines = 0
            if #available(iOS 12.0, *) {
                if traitCollection.userInterfaceStyle == .dark{
                    backLabel.textColor = UIColor.white
                }else{
                    backLabel.textColor = UIColor.black
                }
            } else {
                // Fallback on earlier versions
                backLabel.textColor = UIColor.black
            }
            backLabel.textAlignment = .center
            self.backgroundView = backLabel
        }
    }
}
