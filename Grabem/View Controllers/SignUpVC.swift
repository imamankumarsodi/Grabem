//
//  SignUpVC.swift
//  Grabem
//
//  Created by Callsoft on 10/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class SignUpVC: UIViewController {
    
    @IBOutlet var imgViewCamera: UIImageView!
    @IBOutlet var txtfldFullName: UITextField!
    @IBOutlet var txtfldEmailId: UITextField!
    @IBOutlet var txtfldPhoneNo: UITextField!
    @IBOutlet var txtfldPostCode: UITextField!
    @IBOutlet var txtfldPassword: UITextField!
    var imageData:NSData!
    var imagePicker:UIImagePickerController? = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         imagePicker?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnSkipAction(_ sender: Any) {
        
        
        UserDefaults.standard.set("skip", forKey: "typeChecker")
        let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        tabbar.selectedIndex = 1
        self.navigationController?.pushViewController(tabbar, animated: true)
        
    }
    
    @IBAction func btnCameraAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Choose a photo from", message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        { action -> Void in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                self.imagePicker?.sourceType = UIImagePickerControllerSourceType.camera
                self.present(self.imagePicker!, animated: true, completion: nil)
                
            }else{
                
                let alert = UIAlertView()
                alert.title = "Warning"
                alert.message = "You don't have camera"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
            
        })
        
        
        alertController.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
                
                self.imagePicker?.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
                self.imagePicker?.allowsEditing = false
                
                self.present(self.imagePicker!, animated: true, completion: nil)
            }
            
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        { action -> Void in
            
            
        })
        
        self.present(alertController, animated: true) {
            
        }
        
    }
    @IBAction func btnLogin(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {

        if canContinue(){
            
            signUpApiCall()
            
        }
    }
        
        func canContinue() ->Bool{
            
            var canCantinue:Bool = true
            
            if canCantinue{
                
                canCantinue = CommonMethod.validateEmptyString(name: txtfldFullName.text!, withIdentifier: "full name")
            }
            
            if canCantinue{
                
                canCantinue = CommonMethod.validateEmailWithString(email: txtfldEmailId.text!, withIdentifier: "email")
            }
            
            if canCantinue{
                
                canCantinue = CommonMethod.validatePhoneNumberWithString(number: txtfldPhoneNo.text!, withIdentifier: "phone number")
            }
            
            if canCantinue{
                
                canCantinue = CommonMethod.validateEmptyString(name: txtfldPostCode.text!, withIdentifier: "post code")
            }
            
            if canCantinue{
                
                canCantinue = CommonMethod.validateEmptyString(name: txtfldPassword.text!, withIdentifier: "password")
            }
            return canCantinue
    }


        func signUpApiCall(){
            
            let deviceToken = UserDefaults.standard.object(forKey:"devicetoken") as? String ?? "fbhtr"
            
            if self.imageData == nil{
                
                self.imageData = UIImageJPEGRepresentation(UIImage(named: "fullname_contact.png")!, 1.0)! as NSData!
            }
            print(imageData)
            let parameters = ["fullname": txtfldFullName.text!,"email":txtfldEmailId.text!,"phone":txtfldPhoneNo.text!,"postcode":txtfldPostCode.text!,"password" : txtfldPassword.text!,"confirmpassword":txtfldPassword.text!,"device_id":deviceToken] as [String: String]
                print(parameters)
            
                ServiceClassMethods.AlamoRequestForImage(method: "POST", serviceString: AppConstants.kUserSignUp, parameters: parameters, imageData: imageData) { (dic) in
                
                print("Response Data :\n\(dic)")
                let status =  dic.object(forKey: "status") as! NSString
                let message = dic.object(forKey: "message") as! NSString
                if status == "SUCCESS"{
                
                if let responseDic = dic.object(forKey: "UserSignup") as? NSDictionary{
                
                    let token = responseDic.object(forKey: "token") as? String
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set("True", forKey: "isAlreadyLogin")
                    let uniqueId = responseDic.object(forKey: "unique_user_id") as? String
                    UserDefaults.standard.set(uniqueId, forKey: "unique_user_id")
                    
                    UserDefaults.standard.set("login", forKey: "typeChecker")
                    let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                    tabbar.selectedIndex = 0
                    self.navigationController?.pushViewController(tabbar, animated: true)
                }
                    
            } else if status == "FAILURE"{
                    
                if (message as String) == AppConstants.kAlreadyLoginMsg{
                self.dismiss(animated: false, completion: nil)
                CommonMethod.makeAlertForAlreadyLogin(alertMsg: AppConstants.kAlredyLoginMsgDisplay)
                
                }else{
                
                CommonMethod.makeAlert(alertMsg: message as String)
           }
        }
     }
   }
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            imgViewCamera.layer.cornerRadius = imgViewCamera.layer.frame.size.width / 2
            imgViewCamera.layer.masksToBounds = true
            imgViewCamera.contentMode = .scaleAspectFill
            imgViewCamera.image = pickedImage
           self.imageData = UIImageJPEGRepresentation(CommonMethod.resizeImage(image: pickedImage, newWidth: 414), 1.0)! as NSData!
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}


