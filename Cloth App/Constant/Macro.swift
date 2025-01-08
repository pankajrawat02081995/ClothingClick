
//
//  Macro.swift
//  eLaunch
//
//  Created by Hardik Shekhat on 08/07/18.
//  Copyright © 2018 Hardik Shekhat. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import GooglePlaces
import SafariServices

let PAGESIZE = 10
let STORYIMAGEDURATION = 3.0
let gifManager = SwiftyGifManager(memoryLimit: 50)
let DEFAULT_COUNTRYCODE = "+1"
let DEFAULT_COUNTRYNAME = "Canada"

//MARK: - Device Size Constants -
let IS_IPHONE4s = UIScreen.main.bounds.size.height == 480.0
let IS_IPHONE5 = UIScreen.main.bounds.size.height == 568.0
let IS_IPHONE6 = UIScreen.main.bounds.size.height == 667.0
let IS_IPHONE6P = UIScreen.main.bounds.size.height == 736.0
let IS_IPHONEX = UIScreen.main.bounds.size.height == 812.0
let IS_IPHONEXMax = UIScreen.main.bounds.size.height == 896.0
let IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let screenBounds = UIScreen.main.bounds
let screenScale = UIScreen.main.scale
let screenSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)

let screenWidth = screenSize.width
let screenHeight = screenSize.height

//Common DateFormatter
let dateFormateForReceive = "dd-MM-yyyy"
let dateFormateForSend = "yyyy-MM-dd"

let dateFormateForGet = "yyyy-MM-dd HH:mm:ss"
let dateFormateForDisplay = "dd MMM yyyy HH:mm"
let dateFormateForDisplayForPremun = "MMM dd yyyy HH:mm:ss"

//App Delegate
let appDelegate = UIApplication.shared.delegate as! AppDelegate
@available(iOS 13.0, *)
let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate

let ProfileHolderImage = UIImage.init(named: "user_image")
let PlaceHolderImage = UIImage.init(named: "img_placeholder")
let PlaceHolderImageTeam = UIImage.init(named: "team_placeholder")

enum VERTICALMENU_SIZE : CGFloat {
    case WIDTH = 130
    case HEIGHT = 44
}

//App URL Scheme
let facebookScheme = "fbz" //Client Account
let googleScheme = "com.googleusercontent.apps.116352694559-g2pj1ce08gid6chb7dtk8c80q1om1skd" //Client Account
//com.googleusercontent.apps.116352694559-g2pj1ce08gid6chb7dtk8c80q1om1skd

let googleClientId = "116352694559-g2pj1ce08gid6chb7dtk8c80q1om1skd.apps.googleusercontent.com" //Client Account
let twitterConsumerKey = "zWOjsXgMt4omceSIwUUTNleL4" //Client Account
let twitterConsumerSecret = "QwSH1wAlvDIC2nN7EWBqwBORRPdKpkvkcKhPRC5ANOAFOw68nv" //Client Account
//User Defaults
let defaults = UserDefaults.standard
//MARK: - API URL and Other Keys
//let googleAPIKey = "AIzaSyB76zQ26RAJPlf3CvlTeuP9_nNKh-lWJzc" //Client Account
//let googleMapsDirectionURL = "https://maps.googleapis.com/maps/api/directions/json?"
//indipemdettogethet
let googleAPIKey = "AIzaSyAKepEIu91lqfdqgiHNsy13yJ-VbaQI4vU" ///NEW KEY-Rishi Changed
//let googleAPIKey = "AIzaSyBXYz_JpVMR4LnADwBFYHqFYZrYq-QRXY0" // Old Key //"AIzaSyDrO8BFNrDmqqzCLZ74K8SpPfkflvaHyHE"//"AIzaSyDrO8BFNrDmqqzCLZ74K8SpPfkflvaHyHE"//"AIzaSyCFcfC-pF58WYvFuy7NRg4b4TbgulyBxRE""
let googleMapsDirectionURL = "https://maps.googleapis.com/maps/api/directions/json?"
let APP_APPSTORE_ID = "id1605715607" 
let APP_SHARE_ITUNES_URL = "https://apps.apple.com/us/app/clothing-click-second-hand/id1605715607"
let APP_SHARE_GOOGLE_URL = "http://play.google.com/store/apps/details?id=com.rajasthanroyals.app"
let GiphyAPIKey = "ztphOmapYyQ2P1dzRjQHHrkIq9i3UYCS"
let API_TESTENVIRONMENT_URL = "http://35.158.5.237/jollycar.de/admin/api/"
let API_BASE_URL = API_TESTENVIRONMENT_URL
//App Version
let APP_VERSION = "1"
let DEVICE_TYPE = "Iphone"

//Alert Title And Messages
let AlertViewTitle = "Clothing Click"
let NoInternet = "Sorry, no Internet connectivity detected. Please reconnect and try again"
let ErrorMessage = "Oops something went wrong, please try again later"

//Base URL
let SOCKET_URL = "http://65.0.84.44:2031" //Live
let BASE = "https://apps.clothingclick.online/public/"
//let BASE = "https://staging.clothingclick.online/"
let Forurl = "apps.clothingclick.online/public/"
let SERVER_URL = "\(BASE)api/"
let BASE_URL = "\(SERVER_URL)v1/"
let GOOGLE_GET_CITY_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
//Dabase Path
let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("RaniCircle.sqlite")

//MARK: - Extension

enum GradientColorDirection {
    case vertical
    case horizontal
}

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func showGradientColors(_ colors: [UIColor], opacity: Float = 1, direction: GradientColorDirection = .horizontal) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.opacity = opacity
        gradientLayer.colors = colors.map { $0.cgColor }
        
        if case .horizontal = direction {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        
        gradientLayer.bounds = self.bounds
        gradientLayer.anchorPoint = CGPoint.zero
        self.layer.addSublayer(gradientLayer)
    }
    
    func addTapGesture(target: Any, action: Selector) {
      let tap = UITapGestureRecognizer(target: target, action: action)
      tap.numberOfTapsRequired = 1
      addGestureRecognizer(tap)
      isUserInteractionEnabled = true
    }
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0

        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0

        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}

extension UIViewController {
    func addStatusBarBackgroundView() -> Void {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size:CGSize(width: SCREEN_WIDTH, height: UIApplication.shared.statusBarFrame.height))
        let view : UIView = UIView.init(frame: rect)
        view.backgroundColor = UIColor().alertButtonColor
        self.view.addSubview(view)
    }
    
    func setShadowOfViewWithBorder(view : UIView, borderColor : UIColor) {
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 5.0
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2.0
        view.layer.masksToBounds = false
    }
    
    func setShadowOfViewWithOutBorder(view : UIView, isWithCornerRadius : Bool) {
        if isWithCornerRadius {
            view.layer.cornerRadius = 5.0
        }
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2.0
        view.layer.masksToBounds = false
    }
    
    func setBorderAndRadius(radius : CGFloat, view : UIView, borderWidth : CGFloat, borderColor : UIColor) {
        view.layer.cornerRadius = radius
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.masksToBounds = true
    }
    
    func saveUploadedImageToDocumentDirectory(imgUrl: String, image: UIImage) {
    }
    
    func convertToBlackAndWhite(imge: UIImage) -> UIImage {
        let ciImage = CIImage(image: imge)
        let blackImage = ciImage?.applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey: 0.0])
        return UIImage(ciImage: blackImage!)
    }
    
    func openUrl(urlString: String) {
        if urlString.trim().isEmpty {
            return
        }
        
        var tmpStrUrl = urlString
        if !tmpStrUrl.lowercased().hasPrefix("http://") {
            tmpStrUrl = "http://" + tmpStrUrl
        }
        
        guard let url = URL(string: tmpStrUrl) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //Open Safari ViewController
//        func openSafariViewController(strUrl: String) {
//            if strUrl.trim().isEmpty {
//                return
//            }
//            
//            var tmpStrUrl = strUrl
//            if !tmpStrUrl.lowercased().hasPrefix("http") {
//                tmpStrUrl = "http://" + tmpStrUrl
//            }
//            if let url = URL.init(string: tmpStrUrl) {
//                let svc = SFSafariViewController(url: url)
//                self.present(svc, animated: true, completion: nil)
//            }
//            else {
//                UIAlertController().alertViewWithTitleAndMessage(self, message: "Not a valid url")
//                print("Not a valid url")
//            }
//        }
    
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string, let url = URL(string: urlString) else {
            return false
        }

        if !UIApplication.shared.canOpenURL(url) {
            return false
        }
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    func removeFileFromDocumentDirectory(folderName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(folderName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Files removed successfully.")
        }
        catch {
            print("Error while remove files:", error.localizedDescription)
        }
    }
}

extension UIApplication {
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
}

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 0.5, height: 0.5)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func gradientImage(with bounds: CGRect, colors: [CGColor], locations: [NSNumber]?) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                           y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                         y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    func resizeByByte(maxByte: Int, completion: @escaping (Data) -> Void) {
            var compressQuality: CGFloat = 1
            var imageData = Data()
            var imageByte = self.jpegData(compressionQuality: 1)?.count
            
            while imageByte! > maxByte {
                imageData = self.jpegData(compressionQuality: compressQuality)!
                imageByte = self.jpegData(compressionQuality: compressQuality)?.count
                compressQuality -= 0.1
            }
            
            if maxByte > imageByte! {
                completion(imageData)
            } else {
                completion(self.jpegData(compressionQuality: 1)!)
            }
        }
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
           let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
           let format = imageRendererFormat
           format.opaque = isOpaque
           return UIGraphicsImageRenderer(size: canvas, format: format).image {
               _ in draw(in: CGRect(origin: .zero, size: canvas))
           }
       }
       
//       func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
//           guard kb > 10 else { return Data() } // Prevents user from compressing below a limit (10kb in this case).
//           let bytes = kb * 1024
//           var compression: CGFloat = 1.0
//           let step: CGFloat = 0.05
//           var holderImage = self
//           var complete = false
//           while(!complete) {
//               guard let data = holderImage.jpegData(compressionQuality: 1.0) else { break }
//               let ratio = data.count / bytes
//               if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
//                   complete = true
//                   return data
//               } else {
//                   let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
//                   compression -= (step * multiplier)
//               }
//               guard let newImage = holderImage.resized(withPercentage: compression) else { break }
//               holderImage = newImage
//           }
//
//           return Data()
//       }
    
    func resize(_ image: UIImage) -> Data {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 500.0
        let maxWidth: Float = 500.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.7
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return  imageData!
    }
}

//Get Font Family Names
func getFontFamilyName() {
    for family: String in UIFont.familyNames {
        print("\(family)")
        for names: String in UIFont.fontNames(forFamilyName: family) {
            print("== \(names)")
        }
    }
}

//Set Colors
extension UIColor {
    var alertButtonColor: UIColor {
        return UIColor(named: "Black_Theme_Color")!
    }
    
    var blueColor: UIColor {
        return UIColor(named: "BlueColor")!
    }
    
    var grayColor: UIColor {
        return UIColor(named: "GrayColor")!
    }
    
    var greenColor: UIColor {
        return UIColor(named: "GreenColor")!
    }
    
    var lightBlueColor: UIColor {
        return UIColor(named: "LightBlueColor")!
    }
    
    var lightGrayColor: UIColor {
        return UIColor(named: "LightGrayColor")!
    }
    
    var orangeColor: UIColor {
        return UIColor(named: "OrangeColor")!
    }
    
    var redColor: UIColor {
        return UIColor(named: "RedColor")!
    }
    
    var turquoiseColor: UIColor {
        return UIColor(named: "TurquoiseColor")!
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension Dictionary {
    func jsonString() -> NSString? {
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
        guard jsonData != nil else {return nil}
        let jsonString = String(data: jsonData!, encoding: .utf8)
        guard jsonString != nil else {return nil}
        return jsonString! as NSString
    }
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//Set Font Name
extension String {
    
        var isValidURL: Bool {
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                // it is a link, if the match covers the whole string
                return match.range.length == self.utf16.count
            } else {
                return false
            }
        }
   
    var themeFontName : String {
        return "CREAMPUF"
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: .literal
            , range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        }
        catch {
            print("error: ", error)
            return nil
        }
    }
    
    var validURL: Bool {
        get {
            let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
            return predicate.evaluate(with: self)
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func convertToDictionary() -> [String: AnyObject]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func setStrikeLine() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
    
    //MARK:- Convert UTC To Local Date by passing date formats value
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outGoingFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    //MARK:- Convert Local To UTC Date by passing date formats value
    func localToUTC(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = outGoingFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
}

extension UILabel{
    func addTextSpacing() {
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 6.88, range: NSRange(location: 0, length: self.text!.count))
        self.attributedText = attributedString
    }
}

extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        header.frame.size.height = header.frame.size.height + 10
        self.tableHeaderView = header
    }
}

//Add Alerts
extension UIAlertController {
    func alertViewWithTitleAndMessage(_ viewController: UIViewController, message: String) -> Void {
        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: message, preferredStyle: .alert)
        alert.setAlertButtonColor()
        let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: nil)
        alert.addAction(hideAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func alertViewWithErrorMessage(_ viewController: UIViewController) {
        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: ErrorMessage, preferredStyle: .alert)
        alert.setAlertButtonColor()
        let hideAstion: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: nil)
        alert.addAction(hideAstion)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func alertViewWithNoInternet(_ viewController: UIViewController) {
        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: NoInternet, preferredStyle: .alert)
        alert.setAlertButtonColor()
        let hideAstion: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: nil)
        alert.addAction(hideAstion)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func setAlertButtonColor() {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                self.view.tintColor = UIColor.white
            }
            else {
                self.view.tintColor = UIColor().blueColor
            }
        }
        else {
            self.view.tintColor = UIColor().blueColor
        }
    }
}

extension GMSAutocompleteViewController {
    func setAddressTintColor() {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark  {
              self.primaryTextColor = UIColor.white
              self.secondaryTextColor = UIColor.lightGray
              self.tableCellSeparatorColor = UIColor.lightGray
              self.tableCellBackgroundColor = UIColor.darkGray
           }
        }
    }
}

extension Date {
    // Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    // Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    // Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    // Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    // Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    // Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    // Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    // Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) year ago"   }
        if months(from: date)  > 0 { return "\(months(from: date)) months ago"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) weeks ago"   }
        if days(from: date)    > 0 { return "\(days(from: date)) day ago"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hours ago"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) minutes" }
        if seconds(from: date) > 0 { return "Just Now" }
        return ""
    }
    
    
    func offsetFrom(date: Date) -> String {

           let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
           let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)

           let seconds = "\(difference.second ?? 0)s"
           let minutes = "\(difference.minute ?? 0)m" + " " + seconds
           let hours = "\(difference.hour ?? 0)h" + " " + minutes
           let days = "\(difference.day ?? 0)d" + " " + hours

           if let day = difference.day, day          > 0 { return days }
           if let hour = difference.hour, hour       > 0 { return hours }
           if let minute = difference.minute, minute > 0 { return minutes }
           if let second = difference.second, second > 0 { return seconds }
           return ""
       }
    
    // Returns the a custom time interval description from another date
    func offset1(from date: Date) -> String {
        if hours(from: date) >= 0 {
            return ""
        }
        let hour = abs(hours(from: date))
        let minute = abs(minutes(from: date)) - hour * 60
        return "\(hour) : \(String(format: "%02d", minute))"
    }
    
    
    
    func offsetForHome(date: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
 
        if difference.day != nil && difference.day! >= 1 {
            let hours = "\(difference.hour ?? 0)h left"
            let days = "\(difference.day ?? 0)d" + " " + hours
            if let day = difference.day, day          > 0 { return days }
            if let hour = difference.hour, hour       > 0 { return hours }
        }
        else {
            if difference.hour != nil && difference.hour! < 1 {
                let seconds = "\(difference.second ?? 0)s left"
                let minutes = "\(difference.minute ?? 0)m" + " " + seconds
                if let minute = difference.minute, minute > 0 { return minutes }
                if let second = difference.second, second > 0 { return seconds }
            }
            else{
                let minutes = "\(difference.minute ?? 0)m left"
                let hours = "\(difference.hour ?? 0)h" + " " + minutes
                if let hour = difference.hour, hour       > 0 { return hours }
                if let minute = difference.minute, minute > 0 { return minutes }
            }
        }
        
        return ""
    }
    
    func toLocalTime() -> Date {
        let timeZone = NSTimeZone.local
        let seconds: TimeInterval = Double(timeZone.secondsFromGMT(for: self as Date))
        let localDate = Date(timeInterval: seconds, since: self as Date)
        return localDate
    }
    
    func getDayOfWeek(_ today:String, tag: Int) -> Int? {
        let formatter = DateFormatter()
        if tag == 0 {
            formatter.dateFormat = "yyyy-MM-dd HH:mm a"
        }
        else {
            formatter.dateFormat = "yyyy-MM-dd"
        }
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        switch dayOfMonth {
            case 1, 21, 31: return "st"
            case 2, 22: return "nd"
            case 3, 23: return "rd"
            default: return "th"
        }
    }
    
    func toString() -> String {
        //March 15, 2017 at 5.30 PM
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func convertToSpacificTimeZone(timeZone: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.init(identifier: timeZone)
        let strCurrentDate = dateFormatter.string(from: self)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let currentDate = dateFormatter1.date(from: strCurrentDate) {
            return currentDate.toLocalTime()
        }
        return self
    }
    
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

extension UIDevice {
    var deviceID : String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    func getOS() -> String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                return "iPod Touch 5"
        case "iPod7,1":                                return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":    return "iPhone 4"
        case "iPhone4,1":                              return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                 return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                 return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                 return "iPhone 5s"
        case "iPhone7,2":                              return "iPhone 6"
        case "iPhone7,1":                              return "iPhone 6 Plus"
        case "iPhone8,1":                              return "iPhone 6s"
        case "iPhone8,2":                              return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                 return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                 return "iPhone 7 Plus"
        case "iPhone8,4":                              return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":               return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":               return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":               return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":    return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":          return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":          return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":          return "iPad Air"
        case "iPad5,3", "iPad5,4":                     return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                   return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":          return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":          return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":          return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                     return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                     return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                     return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                     return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                     return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                             return "Apple TV"
        case "i386", "x86_64":                         return "Simulator"
        default:                                       return identifier
        }
    }
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
//        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
//        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

extension AVAsset {
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

extension UIImage {
    func makeFixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
    
    func imageByCroppingImage(_ size : CGSize) -> UIImage {
        let refWidth : CGFloat = CGFloat(self.cgImage!.width)
        let refHeight : CGFloat =  CGFloat(self.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.width, height: size.height)
        let imageRef = self.cgImage!.cropping(to: cropRect)
        
        let cropped : UIImage = UIImage(cgImage: imageRef!, scale: 0, orientation: self.imageOrientation)
        
        return cropped
    }
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UILabel {
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label: UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}

extension UISegmentedControl {
    func selectedSegmentTintColor(_ color: UIColor) {
        self.setTitleTextAttributes([.foregroundColor: color], for: .selected)
    }
    
    func unselectedSegmentTintColor(_ color: UIColor) {
        self.setTitleTextAttributes([.foregroundColor: color], for: .normal)
    }
    
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

extension UINavigationBar {
    func setNavigationBarTransparent() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

extension UIPopoverPresentationController {
    var dimmingView: UIView? {
        return value(forKey: "_dimmingView") as? UIView
    }
}

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    
    func setText(color: UIColor) { if let textField = getTextField() { textField.textColor = color } }
    
    func setPlaceholderText(color: UIColor) { getTextField()?.setPlaceholderText(color: color) }
    
    func setClearButton(color: UIColor) { getTextField()?.setClearButton(color: color) }
    
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
    
    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}

extension UITextField {
    
    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
        
    }
    
    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                    let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    func setPlaceholderText(color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [.foregroundColor: color])
    }
    
    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}

extension UITextView {
    func sizeFit(width: CGFloat) -> CGSize {
        let fixedWidth = width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        return CGSize(width: fixedWidth, height: newSize.height)
    }
    
    func numberOfLine() -> Int {
        let size = self.sizeFit(width: self.bounds.width)
        let numLines = Int(size.height / (self.font?.lineHeight ?? 1.0))

        return numLines
    }
}

extension GMSAutocompleteViewController {
    func setFilter(filterOption: GMSPlacesAutocompleteTypeFilter = GMSPlacesAutocompleteTypeFilter.noFilter ) {
        let filter = GMSAutocompleteFilter()
        filter.type = filterOption
        self.autocompleteFilter = filter
    }
}

func checkIfDatabaseExists(path: String) -> Bool {
    let fileManager: FileManager = FileManager.default
    let isDBExists: Bool = fileManager.fileExists(atPath: path)
    return isDBExists
}

enum FEED_MORE_MENU: String {
    case BLOCK                          = "Block"
    case REPORT                         = "Report"
}
enum USER_TYPE: Int {
    case USER                          = 1
    case STORE                         = 2
    case BRAND                         = 3
}

enum REGISTER_TYPE : String {
    case APP                            = "app"
    case INSTAGRAM                      = "instagram"
    case FACEBOOK                       = "facebook"
    case APPLE                          = "apple"
}

enum SOCIALMEDIA_TYPE : String {
    case INSTAGRAM                      = "Instagram"
    case TIKTOK                         = "Tiktok"
    case YOUTUBE                        = "Youtube"
    case WEB                            = "Web"
}

enum TELLUS_ABOUTSELF_TYPE : String {
    case RELATIONSHIPSTATUS             = "Relationship Status"
    case KIDS                           = "Kids"
    case DRINKING                       = "Drinking"
    case SMOKING                        = "Smoking"
    case EXERCISE                       = "Exercise"
    case PETS                           = "Pets"
    case STARSIGN                       = "Star Sign"
    case RELIGION                       = "Religion"
    case FAMILYLANGUAGES                = "Family Languages"
}

enum FEEDTYPE: String {
    case TEXT                           = "text"
    case IMAGE                          = "image"
    case GIF                            = "gif"
    case VIDEO                          = "video"
    case AUDIO                          = "audio"
    case WEBURL                         = "web_url"
}
enum NOTIFICATIONSTYPE: String {
    case EARNCLICKCOIN                  = "EARN_CLICK_COIN"
    case RATESELLER                     = "RATE_SELLER"
    case WATCHLISTPRICEDROP             = "WATCHLIST_PRICE_DROP"
    case FOLLOW_REQUEST                 = "FOLLOW_REQUEST"
    case ACCEPT_FOLLOW_REQUEST          = "ACCEPT_FOLLOW_REQUEST"
    case NEW_FOLLOWER                   = "NEW_FOLLOWER"
    case MESSAGE_SEND                   = "MESSAGE_SEND"
 
}

enum FEED_ACTION: String {
    case EDIT                           = "Edit"
    case DELETE                         = "Delete"
    case REPORTPOST                     = "Report Post"
}

enum REPORT_TYPE: String {
    case POSTREPORT                     = "PostReport"
    case COMMENTREPORT                  = "CommentReport"
}

enum USER_ACTION: String {
    case TURNONNOTIFICATIONS            = "Turn on Notifications"
    case BLOCKUSER                      = "Block User"
    case UNBLOCKUSER                    = "UnBlock User"
    case UNFRIEND                       = "Unfriend"
    case REPORTUSER                     = "Report User"
}

enum CHATDETAILS_ACTION: String {
    case EXPORT                         = "Export"
    case CLEAR                          = "Clear"
    case ARCHIVE                        = "archive"
    case UNARCHIVE                      = "Unarchive"
}

enum NOTIFICATIONTYPE: String {
    case OTHER                          = "Other"
    case POST_LIKE                      = "Post_Like"
    case ADD_COMMENT                    = "Add_Comment"
    case COMMENT_LIKE                   = "Comment_Like"
    case COMMENT_REPLY                  = "Comment_Reply"
    case COMMENT_REPLY_LIKE             = "Comment_Reply_Like"
    case FRIEND_REQUEST_SEND            = "Friend_Request_Sent"
    case FRIEND_REQUEST_ACCEPTED        = "Friend_Request_Accepted"
    case FRIEND_REQUEST_REJECTED        = "Friend_Request_Rejected"
    case CHAT                           = "Chat"
}

enum APINAME : String {
    case AUTOLOGIN                      = "user/details"
    case OTHER_USER_DETAILS             = "other_user_detail"
    case LOGIN                          = "login"
    case SIGNUP                         = "signup"
    case SIGNUP_STEP2                   = "signup/step2"
    case SIGNUP_VERIFY_USER_PHONE       = "signup/verify_user_phone"
    case CHECK_ACCESS_CODE       = "check_access_code"
    case SET_DEFAULT_LOCATION           = "location/select"
    case LOCATION_DELETE                = "location/delete"
    case LOGOUT                         = "logout"
    case DELETE_ACCOUNT                 = "delete_account"
    case FORGOT_PASSWORD                = "forgot_password"
    case UPDATE_PROFILE                 = "update_profile"
    case BRAND_ADD                      = "brand_add"
    case LIST_OF_SIZE                   = "listsize"
    case LIST_OF_GENDER                 = "listgender"
    case LIST_OF_CATEGORY               = "listcategory"
    case MY_SIZE_LIST                   = "sizes"
    case BRAND_SEARCH                   = "brand/search"
    case SIZES_SAVE                     = "sizes/save"
    case CHANGE_PASSWORD                = "change_password"
    case REPORT_PROBLEM                 = "report_problem"
    case LEAVE_SUGGESTION               = "leave_suggestion"
    case USER_CHANGE_PROFILE_STATUS     = "user/change_profile/status"
    case USER_CHANGE_PROFILE_FINDLOCATION = "user/change_profile/findlocation"
    
    
    // HOME PEGE API
    case HOME_PAGE                      = "dashboard"
    case HOME_LIST_POSTLIST             = "dashboard/post_list"
    case HOME_PAGE_PRODUCTLIST          = "categories/posts"
    
    // Followings Followears api
    case USER_FOLLOWINGS                = "user/followings"
    case USER_FOLLOWERS                 = "user/followers"
    case FOLLOW_USER                    = "follow/user"
    case UNFOLLOW_USER                  = "unfollow/user"
    case GET_NOTIFICATION               = "notifications"
    case NOTIFICATION_SETTING           = "notification/setting"
    case CHAR_ORDER_SETTING             = "update/chat_order_settings"
    case USER_FOLLOW_REQUEST            = "user/follow/requests"
    case USER_FOLLOW_REQUESTS_STATUS    = "user/follow/requests/status"
    case BLOCK_USERS_LIST               = "block_users"
    case UNBLOCK_USER                   = "unblock_user"
    case BLOCK_USER                     = "block_users/create"
    case REPORT_USER                    = "report_user"
    case GET_GENERAL_DATA               = "get_general_data"
    
    //VERIFY ACCOUNR API
    case USER_UPDATE_SOCIAL_ACCOUNT_ID  = "user/update/social_account_id"
    case USER_RESEND_EMAIL_VERIFICATION_LINK = "user/resend/email/verification/link"
   
    //Privacy
    case IS_EMAIL_SHOW                  = "user/email/show"
    case IS_PHONE_SHOW                  = "user/phone/show"
    
    //Qr Code Api
//    case OTHER_USER_DETAILS             = "other_user_detail"
    
    // POST ITEAMS API
    case CATEGORIES_LIST                = "categories_list"
    case CATEGORIES                     = "categories"
    case CATEGORIES_SIZE                = "categories/size"
    case POST_CREATE                    = "post/create"
    case POSE_EDIT                      = "post/update"
    case POST_DETAILS                   = "post/details"
    case FAVOURITE_POST_MANAGE          = "favourite/post/manage"
    case USER_POSTS                     = "user/posts"
    case POST_DELETE                    = "post/delete"
    case POST_SOLD                      = "post/sold"
    
    //Promate Coinse API
    case GET_PROMOTE                    = "promot"
    case ADD_PROMOTE_TO_POT             = "post/promote"
    case EARN_COINS_INFO                = "coins"
    
    //Reviews API
    case ADD_REVIEW                     = "review/add"
    case REVIEWS_LIST                   = "reviews"
    case REVIEW_USER_POST_DETAILS       = "review/user_post/details"
    case POST_SOLD_USER_LIST            = "post/sold/user_list"
    //GlobalSearch
    case GLOBAL_SEARCH                  = "search"
    
    // Create Save Search API
    case SAVE_SEARCH_CREATE             = "save_search/create"
    case FILTER_POST                    = "filter/post"
    case BRAND_POST                     = "brand/posts"
    case SAVE_SEARCH_DETAILS            = "save_search/details"
    case SAVE_SEARCH                    = "save_search"
    case SAVE_SEARCH_UPDATE             = "save_search/update"
    case SAVE_SERCH_DELETE              = "save_search/delete"
    case SAVE_SEARCH_POSTS              = "save_search/posts"
    case FAVOURITE_POST                 = "favourite/post"
    
    // Chat API
    case MESSAGE_SEND                   = "message/send"
    case MESSAGE_DETAILS                = "message/details"
    case MESSAGES                       = "messages"
    case MESSAGEDELETE                  = "message/delete"

    
    // add card
    case PAYMENT_METHOD_ADD             = "payment_method/add"
    case PAYMENT_METHOD                 = "payment_method"
    case PAYMENT_METHOD_DELETE          = "payment_method/delete"
    case PREMIUM_BUY                    = "premium/buy"
    case COINS_BUY                      = "coins/buy"
    case LOCATION_PAY                   = "location/pay"
    
    //FAQ
    case FAQ                            = "faqs"
    
    case STYLES                         = "styles"
    
    case PAYMENTINTENT                  = "create_payment_intent"
    case LIST_ORDER                     = "list_orders"
    case SAVE_ORDER                     = "save_order"
    case ORDER_DETAILS                  = "view_order"
}

//MARK: - API Params -
let kStatus = "status"
let kIsSuccess = 200//success
let kNewUser = 2
let kIsFailure = 0
let kUserNotFound = 401//logout
let kUserBlocked = 403//logout

let kY = "Y"
let kN = "N"
let kYes = "Yes"
let kNo = "No"
let kMessage = "message"
let kData = "data"
let kPage = "page"
let kPageSize = "pagesize"
let kIsNextPage = "nextPageUrl"
let kUserDetails = "data"
let kGeneralSettingDetails = "generalSetting"
let kOk = "Ok"
let kCancel = "Cancel"
let kDeviceToken = "DeviceToken"
let kAuthKey = "auth_key"
let kMetaDataDict = "metaDataDict"
let kHeaderToken = "token"

let kLoginUserList = "loginUserList"
let kNameCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
let kUserNameCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890._"
let DecimalPtsConst = 2

let KBookMarkPopup = "BookMarkPopupShow"

