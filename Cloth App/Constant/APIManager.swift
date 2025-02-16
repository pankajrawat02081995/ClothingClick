//
//  APIManager.swift
//  GoHoota
//
//  Created by Hardik Shekhat on 28/08/17.
//  Copyright © 2018 Hardik Shekhat. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import KRProgressHUD
import ObjectMapper


public class APIManager {
    
    public class var sharedInstance: APIManager {
        struct Singleton {
            static let instance: APIManager = APIManager()
        }
        return Singleton.instance
    }
    
    func apiCall<T:Mappable>(of type: T.Type = T.self,isShowHud: Bool, URL : String, apiName : String, method: HTTPMethod, parameters : [String : Any]?, completion:@escaping (_ dict: BaseResponseModel<T>?,_ error: NSError?) -> ()) {
                
        let api_url = URL + apiName

        if parameters == nil {
            print("API URL = \(api_url)")
        }
        else {
            print("API URL = \(api_url) parameters = \(parameters!)")
        }
        
        var headers: HTTPHeaders = ["accept": "application/json"]
        if appDelegate.headerToken != "" {
            headers["Authorization"] = "Bearer \(appDelegate.headerToken)"
        }
        
        if isShowHud {
            KRProgressHUD.show()
        }
        let request: DataRequest = Alamofire.request(api_url, method: method, parameters: parameters, headers: headers).validate().responseJSON { response in
            if isShowHud {
                KRProgressHUD.dismiss()
            }

            switch response.result {
            case .success:
                let json = try! JSONSerialization.jsonObject(with: response.data!)
                print(response)

                let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json as! [String : Any])
                
                if dataResponse?.status == kIsSuccess {
                    completion(dataResponse!, nil)
                }
                else if dataResponse?.status == kUserNotFound {
                    let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                    alert.setAlertButtonColor()
                    
                    let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                        BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                        BaseViewController.sharedInstance.navigateToWelconeScreen()
                    })
                    alert.addAction(hideAction)
                    sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                else if dataResponse?.status == kUserBlocked {
                    let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                    alert.setAlertButtonColor()
                    
                    let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                        BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                        BaseViewController.sharedInstance.navigateToWelconeScreen()
                    })
                    alert.addAction(hideAction)
                    sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                else{
                    completion(nil, NSError.init(domain: (dataResponse?.message)!, code: (dataResponse?.status)!, userInfo: nil))
                }
            case .failure(let error):
                print (error)
//                completion(nil, NSError.init(domain: ErrorMessage, code: 0, userInfo: nil))
                if let json = try? JSONSerialization.jsonObject(with: response.data!) as? [String : Any] {
                    let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json)
                    print (dataResponse!.message ?? "")
                    if dataResponse?.status == kUserNotFound {
                        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                        alert.setAlertButtonColor()
                        
                        let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                            BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                            BaseViewController.sharedInstance.navigateToWelconeScreen()
                        })
                        alert.addAction(hideAction)
                        sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                    else if dataResponse?.status == kUserBlocked {
                        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                        alert.setAlertButtonColor()
                        
                        let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                            BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                            BaseViewController.sharedInstance.navigateToWelconeScreen()
                        })
                        alert.addAction(hideAction)
                        sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                    else{
                        completion(nil, NSError.init(domain: (dataResponse?.message) ?? "", code: (dataResponse?.status) ?? 0, userInfo: nil))
                    }
                }
                else{
                    completion(nil, NSError.init(domain: ErrorMessage, code: 0, userInfo: nil))
                }
            }
        }
        
        NSLog("%@", request.request?.allHTTPHeaderFields ?? "")
    }

    func apiCallJSON<T:Mappable>(of type: T.Type = T.self,isShowHud: Bool, URL : String, apiName : String, method: HTTPMethod, parameters : [String : Any]?, completion:@escaping (_ dict: BaseResponseModel<T>?,_ error: NSError?) -> ()) {
                
        let api_url = URL + apiName

        if parameters == nil {
            print("API URL = \(api_url)")
        }
        else {
            print("API URL = \(api_url) parameters = \(parameters!)")
        }
        
        var headers: HTTPHeaders? = nil
        if appDelegate.headerToken != "" {
            headers = ["Authorization": "Bearer \(appDelegate.headerToken)"]
        }
        
        if isShowHud {
            KRProgressHUD.show()
        }
        
        let request: DataRequest = Alamofire.request(api_url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            if isShowHud {
                KRProgressHUD.dismiss()
            }

            switch response.result {
            case .success:
                let json = try! JSONSerialization.jsonObject(with: response.data!)
                print(response)

                let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json as! [String : Any])
                
                if dataResponse?.status == kIsSuccess {
                    completion(dataResponse!, nil)
                }
                else if dataResponse?.status == kUserNotFound {
                    let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                    alert.setAlertButtonColor()
                    
                    let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                        BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                        BaseViewController.sharedInstance.navigateToWelconeScreen()
                    })
                    alert.addAction(hideAction)
                    sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                else if dataResponse?.status == kUserBlocked {
                    let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                    alert.setAlertButtonColor()
                    
                    let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                        BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                        BaseViewController.sharedInstance.navigateToWelconeScreen()
                    })
                    alert.addAction(hideAction)
                    sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                else{
                    completion(nil, NSError.init(domain: (dataResponse?.message)!, code: (dataResponse?.status)!, userInfo: nil))
                }
            case .failure(let error):
                print (error)
                if let json = try? JSONSerialization.jsonObject(with: response.data!) as? [String : Any] {
                    let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json)
                    print (dataResponse!.message!)
                    if dataResponse?.status == kUserNotFound {
                        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                        alert.setAlertButtonColor()
                        
                        let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                            BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                            BaseViewController.sharedInstance.navigateToWelconeScreen()
                        })
                        alert.addAction(hideAction)
                        sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                    else if dataResponse?.status == kUserBlocked {
                        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                        alert.setAlertButtonColor()
                        
                        let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                            BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                            BaseViewController.sharedInstance.navigateToWelconeScreen()
                        })
                        alert.addAction(hideAction)
                        sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                    else{
                        completion(nil, NSError.init(domain: (dataResponse?.message)!, code: (dataResponse?.status)!, userInfo: nil))
                    }
                }
            }
        }
        
        NSLog("%@", request.request?.allHTTPHeaderFields ?? "")
    }
    
    //Mark: API call with image upload
    
    //Mark: API call with image upload
    func apiCallWithImageAndVideo<T: Mappable>(of type: T.Type = T.self, isShowHud: Bool, URL: String, apiName: String, parameters: [String: Any], images: UIImage, videoData: Data, imageParameterName: String, imageName: String, completion: @escaping (_ dict: BaseResponseModel<T>?, _ error: NSError?) -> ()) {
        
        let api_url = URL + apiName
        print("API URL = \(api_url) parameters = \(parameters)")

        var headers: HTTPHeaders? = nil
        if !appDelegate.headerToken.isEmpty {
            headers = ["Authorization": "Bearer \(appDelegate.headerToken)"]
        }
        
        if isShowHud {
            KRProgressHUD.show()
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // Append image data
            if let imageData = images.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(imageData, withName: "thumbnail", fileName: "\(imageName)\(Date()).jpeg", mimeType: "image/jpeg")
            }
            
            // Append video data
            multipartFormData.append(videoData, withName: "file", fileName: "video.mp4", mimeType: "video/mp4")
            
            // Append parameters
            for (key, value) in parameters {
                if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: api_url, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if isShowHud {
                        KRProgressHUD.dismiss()
                    }
                    switch response.result {
                    case .success:
                        if let responseData = response.data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any] {
                                    let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json)
                                    
                                    if dataResponse?.status == kIsSuccess {
                                        completion(dataResponse, nil)
                                    } else if dataResponse?.status == kUserNotFound || dataResponse?.status == kUserBlocked {
                                        let alert = UIAlertController(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                                        alert.setAlertButtonColor()
                                        let hideAction = UIAlertAction(title: kOk, style: .default) { _ in
                                            BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                                            BaseViewController.sharedInstance.navigateToWelconeScreen()
                                        }
                                        alert.addAction(hideAction)
                                        sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                                    } else {
                                        completion(nil, NSError(domain: dataResponse?.message ?? "Error", code: dataResponse?.status ?? 0, userInfo: nil))
                                    }
                                }
                            } catch {
                                completion(nil, NSError(domain: ErrorMessage, code: 0, userInfo: nil))
                            }
                        }
                    case .failure(let error):
                        print(error)
                        completion(nil, NSError(domain: ErrorMessage, code: 0, userInfo: nil))
                    }
                }
            case .failure(let encodingError):
                if isShowHud {
                    KRProgressHUD.dismiss()
                }
                print(encodingError)
                completion(nil, NSError(domain: ErrorMessage, code: 0, userInfo: nil))
            }
        })
    }
    
    func apiCallWithImage<T:Mappable>(of type: T.Type = T.self,isShowHud: Bool, URL : String, apiName : String, parameters : [String : Any], images: [UIImage], imageParameterName: String, imageName: String, completion:@escaping (_ dict: BaseResponseModel<T>?,_ error: NSError?) -> ()){
        
        let api_url = URL + apiName
        print("API URL = \(api_url) parameters = \(parameters)")

        var headers: HTTPHeaders? = nil
        if appDelegate.headerToken != "" {
            headers = ["Authorization": "Bearer \(appDelegate.headerToken)"]
        }
        
        if isShowHud {
            KRProgressHUD.show()
        }
      
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            if images.count > 1 {
                for index in 0...images.count - 1{
                    if let imageData = images[index].jpegData(compressionQuality: 0.4) {
                        let imagedata = images[index].resize(images[index])
                        multipartFormData.append(imagedata ?? Data(), withName: "\(imageParameterName)\(index + 1)", fileName: "\(imageName)\(index + 1)", mimeType: "image/png")
                    }
                }
            }
            else {
                if let imageData = images[0].jpegData(compressionQuality: 0.4) {
                    let imagedata = images[0].resize(images[0])
                    multipartFormData.append(imagedata ?? Data(), withName: imageParameterName, fileName: imageName, mimeType: "image/png")
                }
            }
            
            //Append Param
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, usingThreshold: 1, to: api_url, method: .post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: {
                    response in
                    if isShowHud {
                        KRProgressHUD.dismiss()
                    }
                    switch response.result {
                    case .success:
                        
                        let json = try! JSONSerialization.jsonObject(with: response.data!)
                        print(response)

                        let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json as! [String : Any])
                        
                        if dataResponse?.status == kIsSuccess {
                            completion(dataResponse!, nil)
                        }
                        else if dataResponse?.status == kUserNotFound {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                            alert.setAlertButtonColor()
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                                BaseViewController.sharedInstance.navigateToWelconeScreen()
                            })
                            alert.addAction(hideAction)
                            sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                        else if dataResponse?.status == kUserBlocked {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                            alert.setAlertButtonColor()
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                                BaseViewController.sharedInstance.navigateToWelconeScreen()
                            })
                            alert.addAction(hideAction)
                            sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                        else{
                            completion(nil, NSError.init(domain: (dataResponse?.message)!, code: (dataResponse?.status)!, userInfo: nil))
                        }
                    case .failure(let error):
                        print (error)
                        completion(nil, NSError.init(domain: ErrorMessage, code: 0, userInfo: nil))
                    }
                })
            case .failure(let encodingError):
                if isShowHud {
                    KRProgressHUD.dismiss()
                }
                print (encodingError)
                completion(nil, NSError.init(domain: ErrorMessage, code: 0, userInfo: nil))
            }
        })
    }
    
    
    func apiCallWithMultipart<T:Mappable>(of type: T.Type = T.self,isShowHud: Bool, URL : String, apiName : String, parameters : [String : Any], completion:@escaping (_ dict: BaseResponseModel<T>?,_ error: NSError?) -> ()){
        
        let api_url = URL + apiName
        print("API URL = \(api_url) parameters = \(parameters)")

        var headers: HTTPHeaders? = nil
        if appDelegate.headerToken != "" {
            headers = ["Authorization": "Bearer \(appDelegate.headerToken)"]
        }
        
        if isShowHud {
            KRProgressHUD.show()
        }
      
        Alamofire.upload(multipartFormData: {
            multipartFormData in
           
            //Append Param
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, usingThreshold: 1, to: api_url, method: .post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: {
                    response in
                    if isShowHud {
                        KRProgressHUD.dismiss()
                    }
                    switch response.result {
                    case .success:
                        
                        let json = try! JSONSerialization.jsonObject(with: response.data!)
                        print(response)
                        let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json as! [String : Any])
                        
                        if dataResponse?.status == kIsSuccess {
                            completion(dataResponse!, nil)
                        }
                        else if dataResponse?.status == kUserNotFound {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                            alert.setAlertButtonColor()
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                                BaseViewController.sharedInstance.navigateToWelconeScreen()
                            })
                            alert.addAction(hideAction)
                            sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                        else if dataResponse?.status == kUserBlocked {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                            alert.setAlertButtonColor()
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                                BaseViewController.sharedInstance.navigateToWelconeScreen()
                            })
                            alert.addAction(hideAction)
                            sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                        else{
                            completion(nil, NSError.init(domain: (dataResponse?.message)!, code: (dataResponse?.status)!, userInfo: nil))
                        }
                    case .failure(let error):
                        print (error)
                        completion(nil, NSError.init(domain: ErrorMessage, code: 0, userInfo: nil))
                    }
                })
            case .failure(let encodingError):
                if isShowHud {
                    KRProgressHUD.dismiss()
                }
                print (encodingError)
                completion(nil, NSError.init(domain: ErrorMessage, code: 0, userInfo: nil))
            }
        })
    }
}

