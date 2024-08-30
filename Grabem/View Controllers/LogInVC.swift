//
//  LogInVC.swift
//  Grabem
//
//  Created by callsoft on 08/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import SVProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
import InstagramKit
import Alamofire
import InstagramLogin


class LogInVC: UIViewController,InstagramLoginViewControllerDelegate {
    @IBOutlet var txtfldEmail: UITextField!
    @IBOutlet var txtfldPassword: UITextField!
    @IBOutlet var btnRememberMe: UIButton!
    
    var instagramLogin: InstagramLoginViewController!
    let clientId = "19d91f829c59406096f61fff5bb025cf"
    let redirectUri = "http://fireaway.co.uk/"
    var imageData:NSData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          txtfldEmail.text = UserDefaults.standard.string(forKey: "email") ?? ""
          txtfldPassword.text = UserDefaults.standard.string(forKey: "password")  ?? ""
          btnRememberMe.isSelected = UserDefaults.standard.bool(forKey: "isRememberMeSelected")
    
    }

    @IBAction func btnSkipAction(_ sender: Any) {
        
        UserDefaults.standard.set("skip", forKey: "typeChecker")
        let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        tabbar.selectedIndex = 1
        self.navigationController?.pushViewController(tabbar, animated: true)
        
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        
        let otpObjVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(otpObjVC, animated: true)
        
    }
    
    @IBAction func btnForgotPasswordAction(_ sender: Any) {
        
        let otpObjVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(otpObjVC, animated: true)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        if canContinue(){
            
            loginApiCall()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnRememberMeAction(_ sender: Any) {
        
           btnRememberMe.isSelected =  !btnRememberMe.isSelected
        
    }
    
    @IBAction func btnFacebookAction(_ sender: Any) {
        
        fbLogin()
    }
    
    @IBAction func btnTwitterAction(_ sender: Any) {
        
        twitterLogin()
        
    }
    
    @IBAction func btnInstagramAction(_ sender: Any) {
        
        loginWithInstagram()
        
    }
    
    @IBAction func btnEmailAction(_ sender: Any) {
        
      
        
    }
    
    func loginWithInstagram() {
        
        instagramLogin = InstagramLoginViewController(clientId: clientId, redirectUri: redirectUri)
        instagramLogin.delegate = self
        instagramLogin.scopes = [.all]
        instagramLogin.title = "Instagram"
        instagramLogin.progressViewTintColor = .blue
        
        instagramLogin.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissLoginViewController))
        present(UINavigationController(rootViewController: instagramLogin), animated: true)
    }
    
   @objc func  dismissLoginViewController(){
    
      self.instagramLogin.dismiss(animated: true, completion: nil)
    
    
    }
    
    func instagramLoginDidFinish(accessToken: String?, error: InstagramError?) {
       
        print(accessToken)
        
        instaApiCall(accessToken: accessToken!)
        
        dismissLoginViewController()
        
    }
    
    func instaApiCall(accessToken:String){
        
         ServiceClassMethods.AlamoRequest(method: "GET", serviceString: AppConstants.kinstaURL
            + accessToken, parameters: [:], completion: { (dic) in
            print("Response Data :\n\(dic)")
                
                if let responseDic = dic.object(forKey: "data") as? NSDictionary{
                    
                    
                    let fullName = responseDic.object(forKey: "full_name") as? String ?? ""
                    let uniqueId = responseDic.object(forKey: "id") as? String ?? ""
                    let imageUrlForSocial = responseDic.object(forKey: "profile_picture") as? String ?? ""
                    let url1 = URL(string: imageUrlForSocial as String)
                    
                    if url1 != nil{
                        
                        self.imageData = NSData(contentsOf: url1!)
                        
                    }
                    self.socialLoginApiCall(fullname: fullName, email: "", phone: "", postcode: "", imageData: self.imageData, type: "google", Fbid: "", twitterID: "", instaID: uniqueId)
                }
         })
    }

    
    

    func twitterLogin(){
        
        FHSTwitterEngine1.shared().permanentlySetConsumerKey("gTqDXJ9zX5ykiWvd6muZ7x4B9", andSecret: "3666eb3fddc1443dbf289db56740c516")
        FHSTwitterEngine1.shared().delegate = nil
        FHSTwitterEngine1.shared().loadAccessToken()
        
        let twitterLoginController: UIViewController = FHSTwitterEngine1.shared().loginController { (success: Bool)  in
            if(success)
            {
                let dataArray: NSArray = FHSTwitterEngine1.shared().getTimelineForUser(FHSTwitterEngine1.shared().authenticatedID, isID: true, count: 1) as! NSArray
                let id = FHSTwitterEngine1.shared().authenticatedID
                let id1 = FHSTwitterEngine1.shared().accessToken.key
                let id2 = FHSTwitterEngine1.shared().accessToken.secret
                
                if(dataArray.count > 0)
                {
                    let twitterData:NSDictionary = dataArray[0] as! NSDictionary
                    let user:NSDictionary = twitterData.object(forKey: "user") as! NSDictionary
                    print(user)
                    let social_id = user["id_str"] as! NSString!
                    let imageUrlForSocial = user["profile_image_url"] as! NSString!
                    let nameForUser = user["screen_name"] as! NSString!
                    
                    let url1 = URL(string: imageUrlForSocial! as String)
                    
                    if url1 != nil{
                        
                        self.imageData = NSData(contentsOf: url1!)
                        
                    }
                    self.socialLoginApiCall(fullname: nameForUser! as String, email: "", phone: "", postcode: "", imageData: self.imageData!, type: "twitter", Fbid: "", twitterID: social_id as! String, instaID: "")
                    
                }
                else
                {
                    let alertView = UIAlertView(
                        title:"twitter!",
                        message:"We are not able to access your twitter account due to inactive state of your account.",
                        delegate:nil,
                        cancelButtonTitle:nil,
                        otherButtonTitles:"OK")
                    alertView.show()
                }
            }
            else
            {
                let alertView = UIAlertView(
                    title:"twitter!",
                    message:"Your twitter account not be configured",
                    delegate:nil,
                    cancelButtonTitle:nil,
                    otherButtonTitles:"OK")
                alertView.show()
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
        self.present(twitterLoginController, animated: true, completion: nil)
        
    }
    
    func getTweets(){
        
        print("latestWeet")
        let result = FHSTwitterEngine1.shared().getHomeTimeline(sinceID: FHSTwitterEngine1.shared().authenticatedID, count: 10)
        print(result)
        
    }
    
    
    //MARK: facebook login
    
    func fbLogin(){
        
     
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        fbLoginManager .logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error != nil){
                print("error description:%@",error)
            }
            else  if (result?.isCancelled)! {
                
            }
            else{
                let loginResult: FBSDKAccessToken = FBSDKAccessToken.current()
                if(loginResult.permissions.contains("email"))
                {
                    
                    SVProgressHUD.dismiss()
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
                else{
                    
                }
            }
            
        }
        
        
    }
    
    
    //MARK: fb data
    //MARK: get facbook data
    
    func getFBUserData(){
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let dict:NSDictionary = result as! NSDictionary
                    
                    print(dict)
                    var dicOfsocialNetwork:NSDictionary = NSDictionary()
                    let login_type  = "facebook"
                                        
                    let nameForUser:String = dict.object(forKey: "name") as? String ?? ""
                    let firstName:String = dict.object(forKey: "first_name") as? String ?? ""
                    let lastName:String = dict.object(forKey: "last_name") as? String ?? ""
                    
                    let dictForPicture:NSDictionary = dict.object(forKey: "picture") as! NSDictionary
                    let dictForData:NSDictionary = dictForPicture.object(forKey: "data") as! NSDictionary
                    let imageUrlForSocial:String = dictForData.object(forKey: "url") as? String ?? ""
                    let social_id = dict.object(forKey: "id") as? String ?? ""
                    let email = dict.object(forKey: "email") as? String ?? ""
                    dicOfsocialNetwork = ["social_id":social_id,"nameForUser":nameForUser,"imageUrlForSocial":imageUrlForSocial,"login_type":login_type,"email":email]
                  
                    
                    let url1 = URL(string: imageUrlForSocial)
                     
                    if url1 != nil{
                        
                        self.imageData = NSData(contentsOf: url1!)
                        
                    }
                    
                    self.socialLoginApiCall(fullname: nameForUser, email: email, phone: "", postcode: "", imageData: self.imageData!, type: "facebook", Fbid: social_id, twitterID: "", instaID: "")
                    
                    
                }
                
            })
        }
    }
    
    func socialLoginApiCall(fullname:String, email:String, phone: String, postcode:String, imageData:NSData, type:String, Fbid:String,twitterID:String,instaID:String){
        
        let deviceToken = UserDefaults.standard.object(forKey:"devicetoken") as? String ?? "fbhtr"
        
        let parameters = ["fullname": fullname,"email":email,"phone":phone,"postcode":postcode,"device_id":deviceToken,"type":type,"fb_id":Fbid,"twitter_id":twitterID,"google_id":instaID] as [String: String]
        print(parameters)
        
        ServiceClassMethods.AlamoRequestForImage(method: "POST", serviceString: AppConstants.ksocialSignUp, parameters: parameters, imageData: imageData) { (dic) in
            
            print("Response Data :\n\(dic)")
            let status =  dic.object(forKey: "status") as! NSString
            let message = dic.object(forKey: "message") as! NSString
            if status == "SUCCESS"{
                
                if let responseDic = dic.object(forKey: "SocialLogin") as? NSDictionary{
                    
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
                    CommonMethod.makeAlertForAlreadyLogin(alertMsg: AppConstants.kAlredyLoginMsgDisplay)
                    
                }else{
                    
                    CommonMethod.makeAlert(alertMsg: message as String)
                }
            }
        }
}
    
    func canContinue() ->Bool{
        
        var canCantinue:Bool = true
       
        if canCantinue{
            
            canCantinue = CommonMethod.validateEmailWithString(email: txtfldEmail.text!, withIdentifier: "email")
        }
        
        if canCantinue{
            
            canCantinue = CommonMethod.validateEmptyString(name: txtfldPassword.text!, withIdentifier: "password")
        }
        return canCantinue
    }

 func loginApiCall()
     {
        
    let deviceToken = UserDefaults.standard.object(forKey:"devicetoken") as? String ?? "fbhtr"
    let parameters = ["email": txtfldEmail.text! ,"password": txtfldPassword.text!,"device_id":deviceToken]
 
        
        print(parameters)
    SVProgressHUD.show(withStatus: "Loading...")
    SVProgressHUD.setDefaultMaskType(.clear)
    
    ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kUserLogin, parameters: parameters, completion: { (dic) in
        print("Response Data :\n\(dic)")
        let status =  dic.object(forKey: "status") as! NSString
        let message = dic.object(forKey: "message") as! NSString
        if status == "SUCCESS"
        {
            SVProgressHUD.dismiss()
            
            
                if let responseDic = dic.object(forKey: "UserLogin") as? NSDictionary{
                    
                    let token = responseDic.object(forKey: "token") as? String
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set("True", forKey: "isAlreadyLogin")
                    UserDefaults.standard.set(self.txtfldEmail.text!, forKey: "email")
                    UserDefaults.standard.set(self.txtfldPassword.text!, forKey: "password")
                    let uniqueId = responseDic.object(forKey: "unique_user_id") as? String
                    UserDefaults.standard.set(uniqueId, forKey: "unique_user_id")
                    
                    
            }
            
            UserDefaults.standard.set("login", forKey: "typeChecker")
            
            UserDefaults.standard.set(self.btnRememberMe.isSelected, forKey: "isRememberMeSelected")
            let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            self.navigationController?.pushViewController(tabbar, animated: true)
          
            
        }else if status == "FAILURE"
        {
            
            SVProgressHUD.dismiss()
            
            if (message as String) == AppConstants.kAlreadyLoginMsg{
                
                self.dismiss(animated: true, completion: nil)
                CommonMethod.makeAlertForAlreadyLogin(alertMsg: AppConstants.kAlredyLoginMsgDisplay)
                
            }else{
                
                CommonMethod.makeAlert(alertMsg: message as String)
                
         }
       }
    })
  }
}




//27ac0855b616514c9c0c050e771cf7cfae30b454 grabem
//dc4ac6d27c5987941d9182c71cc934ae9ae56bd0 ofc 5s
//dff24bae3f6c4de585db93a205b31e346ab538b6 6s
//0cf7a121327bd606fb013ded017750f2d983795a new 5s



