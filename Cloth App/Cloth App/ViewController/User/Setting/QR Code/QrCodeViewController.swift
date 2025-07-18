//
//  QrCodeViewController.swift
//  ClothApp
//
//  Created by Apple on 14/05/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

//import UIKit
//import MercariQRScanner
//
//class QrCodeViewController: BaseViewController {
//
//    @IBOutlet weak var imgQRCode: UIImageView!
//    @IBOutlet weak var btnShere: UIButton!
//    @IBOutlet weak var CVQr: UICollectionView!
//    @IBOutlet weak var viewQRCode: UIView!
//    @IBOutlet weak var viewQRCodeScan: QRScannerView!{
//        didSet {
//            viewQRCodeScan.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
//        }
//    }
//    
//    var otherUserData : UserDetailsModel?
//    var userName = ""
//    var selIndex = 0
//    var categoryList = ["My code","Scan code"]
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.viewQRCodeScan.isHidden = true
//        if let name = appDelegate.userDetails?.username{
//            self.imgQRCode.image = self.generateQRCode(from: "\(name)")
//        }
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.viewQRCodeScan.stopRunning()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if !self.viewQRCodeScan.isHidden {
//        self.viewQRCodeScan.rescan()
//            self.viewQRCodeScan.startRunning()
//        }
//    }
//    
//    @IBAction func btnShere_Clicked(_ button: UIButton) {
//        let url = URL.init(string: "\(SERVER_URL)share/profile/\(appDelegate.userDetails?.username ?? "")")
//        let objectsToShare = [url as Any] as [Any]
//        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        self.present(activityVC, animated: true, completion: nil)
//    }
//    
//    func generateQRCode(from string: String) -> UIImage? {
//        let data = string.data(using: String.Encoding.ascii)
//
//        if let filter = CIFilter(name: "CIQRCodeGenerator") {
//            filter.setValue(data, forKey: "inputMessage")
//            let transform = CGAffineTransform(scaleX: 10, y: 10)//CGAffineTransform(scaleX: 3, y: 3)
//
//            if let output = filter.outputImage?.transformed(by: transform) {
//                return UIImage(ciImage: output)
//            }
//        }
//        return nil
//    }
//}
//extension QrCodeViewController: UICollectionViewDelegate,UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.categoryList.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
//            if self.selIndex == indexPath.item {
//                cell.lblcategory.textColor = UIColor.black
//                cell.viewLine.isHidden = false
//                cell.lblcategory.text = self.categoryList[indexPath.item]
//            }
//            else{
//                cell.lblcategory.textColor = UIColor.init(named: "DarkGrayColor")
//                cell.lblcategory.text = self.categoryList[indexPath.item]
//                cell.viewLine.isHidden = true
//            }
//            return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.selIndex = indexPath.item
//        if indexPath.item == 0 {
//            self.viewQRCodeScan.stopRunning()
//            self.viewQRCode.isHidden = false
//            self.viewQRCodeScan.isHidden = true
//        }else {
//            self.viewQRCodeScan.rescan()
//            self.viewQRCode.isHidden = true
//            self.viewQRCodeScan.isHidden = false
//            self.viewQRCodeScan.startRunning()
//        }
//        self.CVQr.reloadData()
//    }
//}
//
//extension QrCodeViewController: UICollectionViewDelegateFlowLayout {
//    fileprivate var sectionInsets: UIEdgeInsets {
//          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//      }
//      
//      fileprivate var itemsPerRow: CGFloat {
//          return 2
//      }
//      
//      fileprivate var interitemSpace: CGFloat {
//            return 0.0
//      }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width / 2, height: 50)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return interitemSpace
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return interitemSpace
//    }
//}
//
//extension QrCodeViewController : QRScannerViewDelegate {
//    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
//        print(error.localizedDescription)
//    }
//
//    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
//        print(code)
//       // if self.viewQRCodeScan.isHidden {
//            self.callOtherDetails(username: code)
//      //  }
//    }
//}
//
//extension QrCodeViewController {
//    func callOtherDetails(username : String) {
//        if appDelegate.reachable.connection != .none {
//            
//            let param = ["username":  username
//                        ]
//            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.OTHER_USER_DETAILS.rawValue, parameters: param) { (response, error) in
//                if error == nil {
//                    if let response = response {
//                        if let data = response.dictData{
//                            self.otherUserData = data
//                        }
//                        if appDelegate.userDetails?.id == self.otherUserData?.id {
//                            self.navigateToHomeScreen(selIndex: 4)
//                        }
//                        else {
//                            if let seller = self.otherUserData?.role_id {
//                                if seller == 1 {
//                                    let viewController = self.storyboard?.instantiateViewController(identifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
//                                    viewController.userId = "\(self.otherUserData?.id ?? 0)"
//                                    self.navigationController?.pushViewController(viewController, animated: true)
//                                }
//                                else if seller == 2{
//                                    let viewController = self.storyboard?.instantiateViewController(identifier: "StoreProfileViewController") as! StoreProfileViewController
//                                    viewController.userId = "\(self.otherUserData?.id ?? 0)"
//                                    self.navigationController?.pushViewController(viewController, animated: true)
//                                }
//                                else {
//                                    let viewController = self.storyboard?.instantiateViewController(identifier: "BrandProfileViewController") as! BrandProfileViewController
//                                    viewController.userId = "\(self.otherUserData?.id ?? 0)"
//                                    self.navigationController?.pushViewController(viewController, animated: true)
//                                }
//                            }
//                        }
//                    }
//                }
//                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
//                }
//            }
//        }
//        else {
//            UIAlertController().alertViewWithNoInternet(self)
//        }
//    }
//}
