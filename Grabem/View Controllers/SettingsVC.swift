//
//  SettingsVC.swift
//  Grabem
//
//  Created by Callsoft on 10/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
import DropDown


class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageForUserProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var txtfldEmailId: UITextField!
    @IBOutlet var txtfldPhoneNo: UITextField!
    @IBOutlet var txtfldGender: UITextField!
    @IBOutlet var txtfldPostCode: UITextField!
    var imageData:NSData = NSData()
    var imagePicker:UIImagePickerController? = UIImagePickerController( )
    var dropdown = DropDown()
    
    @IBOutlet var btnGender: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        imagePicker?.delegate = self
        txtfldEmailId.isUserInteractionEnabled = false
        txtfldPhoneNo.isUserInteractionEnabled = false
        txtfldGender.isUserInteractionEnabled = false
        txtfldPostCode.isUserInteractionEnabled = false
        imageForUserProfile.layer.cornerRadius = imageForUserProfile.layer.frame.size.width / 2
        imageForUserProfile.layer.masksToBounds = true
        imageForUserProfile.contentMode = .scaleAspectFill
        viewProfileApiCall()

        // Do any additional setup after loading the view.
    }
    
   

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
        if  (String(describing: UserDefaults.standard.value(forKey: "isAlreadyLogin")!) == "True"){
            
        }else{
            
            self.navigationController?.popViewController(animated: false)
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
          editProfileApiCall()
        
    }
    @IBAction func btnCameraAction(_ sender: Any) {
        
        pickImage()
        
    }
    
    @IBAction func tap_scannedRestaurantBtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "VisitedRestaurantListVC") as! VisitedRestaurantListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func pickImage()
    {
        let alertController = UIAlertController(title: "Choose a photo from", message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        { action -> Void in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                self.imagePicker?.sourceType = UIImagePickerControllerSourceType.camera
                self.present(self.imagePicker!, animated: true, completion: nil)
            }
            else
            {
                
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
        self.present(alertController, animated: true)
        
    }

    
    @IBAction func btnEmailAction(_ sender: Any) {
        
        txtfldEmailId.isUserInteractionEnabled = true
        txtfldEmailId.becomeFirstResponder()
    }
    
    @IBAction func btnPhoneAction(_ sender: Any) {
        
        txtfldPhoneNo.isUserInteractionEnabled = true
        txtfldPhoneNo.becomeFirstResponder()
    }
    
    
    @IBAction func btnGenderAction(_ sender: Any) {
        
        dropdown.dataSource = [
            "Male",
            "Female"
        ]
        dropdown.direction = .any
        dropdown.selectionAction = { [unowned self] (index, item) in
            
            self.txtfldGender.text = item
            
        }
        dropdown.anchorView = btnGender
        
        if dropdown.isHidden {
            dropdown.show()
        } else {
            dropdown.hide()
        }
        
    }
    
    
    @IBAction func btnPostcodeAction(_ sender: Any) {
        
        txtfldPostCode.isUserInteractionEnabled = true
        txtfldPostCode.becomeFirstResponder()
        
    }
    
    @IBAction func btnChangePasswordAction(_ sender: Any) {
        
        let otpObjVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(otpObjVC, animated: true)
        
    }
    
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                
               
                imageForUserProfile.image = pickedImage
                self.imageData = UIImageJPEGRepresentation(CommonMethod.resizeImage(image: pickedImage, newWidth: 414), 1.0)! as NSData!
               
            }
            dismiss(animated: true, completion: nil)
            
        }
    
    
    func showAlertView(){
        
        let alertController = UIAlertController(title: "", message: "Do you really want to logout?", preferredStyle:UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            
            self.btnLogOutApiCall()
            
        })
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        { action -> Void in
            
            self.dismiss(animated: false, completion:nil)
            
        })
        
        self.present(alertController, animated: true)
        
    }
  
    
    @IBAction func btnLogOutAction(_ sender: Any) {
        
        showAlertView()
        
    }
    
    
    func btnLogOutApiCall(){
        
    let tokenString =  UserDefaults.standard.object(forKey:"token") as? String ?? ""
    let parameters = ["token": tokenString ]
    print(parameters)
    
    SVProgressHUD.show(withStatus: "Loading...")
    SVProgressHUD.setDefaultMaskType(.clear)
    
    ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kLogout, parameters: parameters, completion: { (dic) in
    print("Response Data :\n\(dic)")
    let status =  dic.object(forKey: "status") as! NSString
    let message = dic.object(forKey: "message") as! NSString
    if status == "SUCCESS"
    {
    
        UserDefaults.standard.set("False", forKey: "isAlreadyLogin")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as? LogInVC
        let navController = UINavigationController(rootViewController: vc!)
        navController.navigationBar.isHidden = true
        self.present(navController, animated: false, completion: nil)
        UserDefaults.standard.set("", forKey: "token")
        SVProgressHUD.dismiss()
    
    }else if status == "FAILURE"
    
    {
              SVProgressHUD.dismiss()
              if (message as String) == AppConstants.kAlreadyLoginMsg{
    
              CommonMethod.makeAlertForAlreadyLogin(alertMsg: AppConstants.kAlredyLoginMsgDisplay)
    
    }else{
    
              CommonMethod.makeAlert(alertMsg: message as String)
    
         }
    
       }
    })
}
    
    func viewProfileApiCall() {
        
        let tokenString =  UserDefaults.standard.object(forKey:"token") as? String ?? ""
        let parameters = ["token": tokenString]
       ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kViewProfile, parameters: parameters, completion: { (dic) in
            print("Response Data :\n\(dic)")
            let status =  dic.object(forKey: "status") as! NSString
            let message = dic.object(forKey: "message") as! NSString

            if status == "SUCCESS" {
                
                SVProgressHUD.dismiss()
                if let responseDic = dic.object(forKey: "View_Profile") as? NSDictionary{
                    
                    let name =  responseDic.object(forKey: "fullname") as? String ?? ""
                    let email = responseDic.object(forKey: "email") as? String ?? ""
                    let phoneNo = responseDic.object(forKey: "phone") as? String ?? ""
                    let postCode = responseDic.object(forKey: "postcode") as? String ?? ""
                    let gender = responseDic.object(forKey: "gender") as? String ?? ""
                    let profileImg = responseDic.object(forKey: "image") as? String ?? ""
                    
                    self.txtfldEmailId.text = email
                    self.txtfldPhoneNo.text = phoneNo
                    self.txtfldGender.text = gender
                    self.txtfldPostCode.text = postCode
                    self.lblName.text = name
                    
                    let url1 = URL(string: profileImg)
                    if url1 != nil
                    {
                        self.imageForUserProfile.af_setImage(withURL: url1!, placeholderImage:UIImage(named:"default_image"))
                    }else{
                        
                        self.imageForUserProfile.image = UIImage(named:"default_image")
                    }
                }
            }
            else if status == "FAILURE"{
                
                SVProgressHUD.show()
                
                if (message as String) == AppConstants.kAlreadyLoginMsg{
                    self.dismiss(animated: false, completion: nil)
                    CommonMethod.makeAlertForAlreadyLogin(alertMsg: AppConstants.kAlredyLoginMsgDisplay)
                    
                }else{
                    
                    CommonMethod.makeAlert(alertMsg: message as String)
                    
                }
            }
        })
    }

    
    func editProfileApiCall() {
        
        if self.imageData == nil{
            
            self.imageData = UIImageJPEGRepresentation(UIImage(named: "default_image.png")!, 1.0)! as NSData!
        }
        
        let tokenString =  UserDefaults.standard.object(forKey:"token") as? String ?? ""
        let parameters = ["fullname":lblName.text!,"email": txtfldEmailId.text! ,"phone": txtfldPhoneNo.text!,"gender":txtfldGender.text!,"postcode":txtfldPostCode.text!,"token":tokenString]

       ServiceClassMethods.AlamoRequestForImage(method: "POST", serviceString: AppConstants.kEditProfile, parameters: parameters, imageData: imageData) { (dic) in
        
            print("Response Data :\n\(dic)")
            let status =  dic.object(forKey: "status") as! NSString
            let message = dic.object(forKey: "message") as! NSString
            if status == "SUCCESS" {

                
                CommonMethod.makeAlert(alertMsg: message as String)


            }
            else if status == "FAILURE"{

                if (message as String) == AppConstants.kAlreadyLoginMsg{
                    CommonMethod.makeAlertForAlreadyLogin(alertMsg: AppConstants.kAlredyLoginMsgDisplay)

                }else{

                    CommonMethod.makeAlert(alertMsg: message as String)

                }
            }
        }
    }
}

