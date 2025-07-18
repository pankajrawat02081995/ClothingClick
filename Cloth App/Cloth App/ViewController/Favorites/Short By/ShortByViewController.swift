//
//  ShortByViewController.swift
//  ClothApp
//
//  Created by Apple on 05/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

protocol ShortByDelegate {
    func selectShortBy(sort_by: String,sort_value: String)
}

class ShortByViewController: BaseViewController {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnDateNewOld: UIButton!
    @IBOutlet weak var btnDateOldNew: UIButton!
    @IBOutlet weak var btnPricelowHigh: UIButton!
    @IBOutlet weak var btnPriceHighlow: UIButton!
    @IBOutlet weak var btnDistancCloseFar: UIButton!
    @IBOutlet weak var btnByCategory: UIButton!
    @IBOutlet weak var btnByMySize: UIButton!
    @IBOutlet weak var consTopForBtnByCategory: NSLayoutConstraint!
    @IBOutlet weak var imgDateNewOld: UIImageView!
    @IBOutlet weak var imgDateOldNew: UIImageView!
    @IBOutlet weak var imgPricelowHigh: UIImageView!
    @IBOutlet weak var imgPriceHighlow: UIImageView!
    @IBOutlet weak var imgDistancCloseFar: UIImageView!
    @IBOutlet weak var imgByCategory: UIImageView!
    @IBOutlet weak var imgByMysize: UIImageView!
    
    @IBOutlet weak var btnShortHide: UIButton!

    //@IBOutlet weak var btnByCategory: UIButton
    
    var shortByDeleget : ShortByDelegate!
    var index = 0
    var isUser = false
    var sort_by = "date"
    var sort_value = "desc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgDateNewOld.isHidden = true
        self.imgDateOldNew.isHidden = true
        self.imgPricelowHigh.isHidden = true
        self.imgPriceHighlow.isHidden = true
        self.imgDistancCloseFar.isHidden = true
        self.imgByCategory.isHidden = true
        
        if self.isUser{
            self.btnDistancCloseFar.isHidden = true
            self.btnByCategory.isHidden = true
            self.consTopForBtnByCategory.constant = -81
        }
        else {
            self.consTopForBtnByCategory.constant = 5
        }
        
        let image = UIImage(named: "close_ic_white")?.imageWithColor(color1: UIColor.init(hex: "000000"))
        self.btnClose.setImage(image, for: .normal)
        
        if self.sort_by == "date" && self.sort_value == "desc" {
            self.imgDateNewOld.isHidden = false
        }
        else if self.sort_by == "date" && self.sort_value == "asc" {
            self.imgDateOldNew.isHidden = false
        }
        else if self.sort_by == "price" && self.sort_value == "asc" {
            self.imgPricelowHigh.isHidden = false
        }
        else if self.sort_by == "price" && self.sort_value == "desc" {
            self.imgPriceHighlow.isHidden = false
        }
        else if self.sort_by == "distance" && self.sort_value == "asc" {
            self.imgDistancCloseFar.isHidden = false
        }
        else if self.sort_by == "category" && self.sort_value == "asc" {
            self.imgByCategory.isHidden = false
        }
        else if self.sort_by == "size" && self.sort_value == "asc" {
            self.imgByMysize.isHidden = false
        }
        
    }
    
    @IBAction func btnClose_Clicked(_ button: UIButton) {

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDateNewOld_Clicked(_ button: UIButton) {
        self.imgDateNewOld.isHidden = false
        self.imgDateOldNew.isHidden = true
        self.imgPricelowHigh.isHidden = true
        self.imgPriceHighlow.isHidden = true
        self.imgDistancCloseFar.isHidden = true
        self.imgByCategory.isHidden = true
        if shortByDeleget != nil{
            self.shortByDeleget.selectShortBy(sort_by: "date", sort_value: "desc")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDateOldNew_Clicked(_ button: UIButton) {
        self.imgDateNewOld.isHidden = true
        self.imgDateOldNew.isHidden = false
        self.imgPricelowHigh.isHidden = true
        self.imgPriceHighlow.isHidden = true
        self.imgDistancCloseFar.isHidden = true
        self.imgByCategory.isHidden = true
        if shortByDeleget != nil{
            self.shortByDeleget.selectShortBy(sort_by: "date", sort_value: "asc")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPricelowHigh_Clicked(_ button: UIButton) {
        self.imgDateNewOld.isHidden = true
        self.imgDateOldNew.isHidden = true
        self.imgPricelowHigh.isHidden = false
        self.imgPriceHighlow.isHidden = true
        self.imgDistancCloseFar.isHidden = true
        self.imgByCategory.isHidden = true
        if shortByDeleget != nil{
            self.shortByDeleget.selectShortBy(sort_by: "price", sort_value: "asc")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPriceHighlow_Clicked(_ button: UIButton) {
        self.imgDateNewOld.isHidden = true
        self.imgDateOldNew.isHidden = true
        self.imgPricelowHigh.isHidden = true
        self.imgPriceHighlow.isHidden = false
        self.imgDistancCloseFar.isHidden = true
        self.imgByCategory.isHidden = true
        if shortByDeleget != nil{
            self.shortByDeleget.selectShortBy(sort_by: "price", sort_value: "desc")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDistancCloseFar_Clicked(_ button: UIButton) {
        self.imgDateNewOld.isHidden = true
        self.imgDateOldNew.isHidden = true
        self.imgPricelowHigh.isHidden = true
        self.imgPriceHighlow.isHidden = true
        self.imgDistancCloseFar.isHidden = false
        self.imgByCategory.isHidden = true
        if shortByDeleget != nil{
            self.shortByDeleget.selectShortBy(sort_by: "size", sort_value: "asc")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnByCategory_Clicked(_ button: UIButton) {
        self.imgDateNewOld.isHidden = true
        self.imgDateOldNew.isHidden = true
        self.imgPricelowHigh.isHidden = true
        self.imgPriceHighlow.isHidden = true
        self.imgDistancCloseFar.isHidden = true
        self.imgByCategory.isHidden = false
        if shortByDeleget != nil{
            self.shortByDeleget.selectShortBy(sort_by: "category", sort_value: "asc")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnByMySize_Clicked(_ button: UIButton) {
        self.imgDateNewOld.isHidden = true
        self.imgDateOldNew.isHidden = true
        self.imgPricelowHigh.isHidden = true
        self.imgPriceHighlow.isHidden = true
        self.imgDistancCloseFar.isHidden = true
        self.imgByCategory.isHidden = true
        self.imgByMysize.isHidden = false
        if shortByDeleget != nil{
            self.shortByDeleget.selectShortBy(sort_by: "size", sort_value: "asc")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
