//
//  ServiceClassMethods.swift
//  benbilirim
//
//  Created by Devendra Agnihotri on 18/03/16.
//  Copyright © 2016 mobulous. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class ServiceClassMethods: NSObject {
    
    
     class func AlamoRequest(method:String,serviceString:String,parameters:[String : Any]?, completion: @escaping (_ dic: NSDictionary) -> Void) {
        var json:NSDictionary!
        let modifiedURLString = NSMutableString(format:"%@%@", AppConstants.kBASE_SERVICE_URL,serviceString) as NSMutableString
        
      if Reachability.isConnectedToNetwork() == true {
        
        if method == "POST" {
            
            if serviceString != AppConstants.kSaveChatHistory && serviceString != AppConstants.kUpdateLocation  {
                
                 SVProgressHUD.show(withStatus: "Loading.")
                 SVProgressHUD.setDefaultMaskType(.clear)
            
            }
            Alamofire.request(modifiedURLString as String, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                    print(response.request!)
                    print(response.result)
                    if let JSON = response.result.value  {
                        print("JSON: \(JSON)")
                        
                        json = JSON as! NSDictionary
                        completion(json)
                        SVProgressHUD.dismiss()
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        print("It may be json Error or network error")
                        
//                        let json = ["status" : "FAILURE","message" : "It seems network is slow!","requestKey" : serviceString]
                        
                        let json = ["status" : "FAILURE","message" : "Seems like a glitch. Please try again!", "requestKey" : serviceString]
                        
                          completion(json as NSDictionary)
                        
                    
                    }
            }
            
            
        }else{
            
            
            SVProgressHUD.show(withStatus: "Loading...")
            SVProgressHUD.setDefaultMaskType(.clear)
            Alamofire.request(serviceString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                print(response.request!)
                print(response.result)
                if let JSON = response.result.value  {
                    print("JSON: \(JSON)")
                    
                    json = JSON as! NSDictionary
                    completion(json)
                    SVProgressHUD.dismiss()
                }
                else
                {
                    SVProgressHUD.dismiss()
                    print("It may be json Error or network error")
                    
                    let json = ["status" : "FAILURE","message" : "It seems network is slow!","requestKey" : serviceString]
                    
                    completion(json as NSDictionary)
                    
                    
                }
            }
            
           }
        }
        else{
        
        SVProgressHUD.dismiss()
        let alert = UIAlertView(title: "No Internet Connection", message: "Network Connection Unavailable. Please check that you have a data connection and try again.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        print("network error")
        
        }
        
    }
    
    
    //#MARK: -ImageData Service
    
    class func AlamoRequestForImage(method:String,serviceString:String,parameters:[String : String]?,imageData : NSData,completion: @escaping (_ result: NSDictionary) -> Void) {
        var json:NSDictionary!
        
        let modifiedURLString = NSMutableString(format:"%@%@", AppConstants.kBASE_SERVICE_URL,serviceString) as NSMutableString
        
        if Reachability.isConnectedToNetwork() == true {
        
            SVProgressHUD.show(withStatus: "Loading...")
            SVProgressHUD.setDefaultMaskType(.clear)
            
        if method == "POST" {
            
           // Alamofire.upload
            let url = try! URLRequest(url: URL(string:modifiedURLString as String)!, method: .post, headers: nil)
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if imageData.length != 0{
                    
                    multipartFormData.append(imageData as Data, withName: "image", fileName: "image.png", mimeType: "image/png")
                    
                }
               
                
                for (key, value) in parameters! {
                    
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    
                }

            }, with: url, encodingCompletion: { (result) in
                
                switch result {
                    
                case .success(let upload, _, _):
                    print("s")
                   
                    upload.responseJSON { response in
                        
                        print(response.response) // URL response
                        print(response.result)
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            json = JSON as! NSDictionary
                            completion(json)
                             SVProgressHUD.dismiss()
                            
                        }else
                        {
                             SVProgressHUD.dismiss()
                            print("It may be json Error or network error")
                            
                            let json = ["status" : "FAILURE","message" : "It seems network is slow!","requestKey" : serviceString]
                            
                            completion(json as NSDictionary)
                            
                        }
                        
                    }
                    
                    
                case .failure(let encodingError):
                     SVProgressHUD.dismiss()
                  //  CommonMethod.endKRprogrssHud()
                    print("It may be json Error or network error")
                    let json = ["status" : "FAILURE","message" : "It seems network is slow!","requestKey" : serviceString]
                    completion(json as NSDictionary)
                    print(encodingError)
                    
                }


            })
         }
        else{
             SVProgressHUD.dismiss()
            print("It may be json Error or network error")
            
            let json = ["status" : "FAILURE","message" : "Network Error","requestKey" : serviceString]
            
            completion(json as NSDictionary)
            
            
           }
            
        }else{
            SVProgressHUD.dismiss()
            print("It may be json Error or network error")
            print("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Network Connection Unavailable. Please check that you have a data connection and try again.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            print("network error")
        }
    
    }
    
    
    class func AlamoRequestFormultipleImage(method:String,serviceString:String,parameters:[String : AnyObject]?, imagegroup1:[NSData],imagegroup2:[NSData],mainImage:NSData,completion: @escaping (_ result: NSDictionary) -> Void) {
        var json:NSDictionary!
        
        let modifiedURLString = NSMutableString(format:"%@%@", AppConstants.kBASE_SERVICE_URL,serviceString) as NSMutableString
            if method == "POST" {
                // Alamofire.upload
                let url = try! URLRequest(url: URL(string:modifiedURLString as String)!, method: .post, headers: nil)
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(mainImage as Data, withName:"evimage"
                        , fileName: "evimage.png", mimeType: "evimage/png")

                    for i in 0..<imagegroup1.count
                    {
                        let imageData = imagegroup1[i]
                            multipartFormData.append(imageData as Data, withName:"image[]"
                                , fileName: String(format:"image%d.jpg",i), mimeType: "image/png")
                    
                    }
                    
                    for i in 0..<imagegroup2.count
                    {
                        let imageData = imagegroup2[i]
                        multipartFormData.append(imageData as Data, withName:"image1[]"
                            , fileName: String(format:"image%d.jpg",i), mimeType: "image/png")
                        
                    }

                    for (key, value) in parameters! {
                        
                       
                        if key == "free" || key == "paid"{
                            
                            let JSON = try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted])
                            let jsonPrasatation = String(data: JSON!, encoding: .utf8)
                            multipartFormData.append((jsonPrasatation?.data(using: String.Encoding.utf8)!)!, withName: key)
                            
                        }else{
                        
                         multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                    }
                    
                }, with: url, encodingCompletion: { (result) in
                    
                    switch result {
                        
                    case .success(let upload, _, _):
                        print("s")
                        
                        upload.responseJSON { response in
                            
                            print(response.response)
                            print(response.result)
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                json = JSON as! NSDictionary
                                completion(json)
                                
                            }else
                            {
                                print("It may be json Error or network error")
                                
                                let json = ["status" : "FAILURE","message" : "There is a no interconnection!","requestKey" : serviceString]
                                
                                completion(json as NSDictionary)
                            }
                        }
                    case .failure(let encodingError):
                        print("It may be json Error or network error")
                        let json = ["status" : "FAILURE","message" : "There is a no interconnection!","requestKey" : serviceString]
                        completion(json as NSDictionary)
                        print(encodingError)
                    }
                })
            }
    
        else{
            print("It may be json Error or network error")
            let json = ["status" : "FAILURE","message" : "Network Error","requestKey" : serviceString]
            completion(json as NSDictionary)
        }
  
    }
    
   class func downloadAudioFromUrl(ulrAudio: String, fileName: String, completionHandler: @escaping (_ savedFilePath:URL) -> Void) {
    
    
      
    
    
    
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            documentsURL.appendPathComponent("\(fileName).caf")
            return (documentsURL, [.removePreviousFile])
        }
        
        Alamofire.download(ulrAudio, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseString(completionHandler: { (response) in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value ?? "")")
                completionHandler(documentsURL)
                
            })
        
    }
}
