//
//  ChangePasswordVC.swift
//  Grabem
//
//  Created by Callsoft on 10/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordVC: UIViewController {

    @IBOutlet var txtfldOldPassword: UITextField!
    @IBOutlet var txtfldNewPassword: UITextField!
    @IBOutlet var txtfldConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnProceedAction(_ sender: Any) {
        
        if canContinue()
        {
            changePasswordApiCall()
        }
       
    }

func canContinue() ->Bool{
    
    var canCantinue:Bool = true
    
    if canCantinue{
        
        canCantinue = CommonMethod.validateEmptyString(name: txtfldOldPassword.text!, withIdentifier: "old password")
    }
    
    if canCantinue{
        
        canCantinue = CommonMethod.validateEmptyString(name: txtfldNewPassword.text!, withIdentifier: "new password")
    }
    
    if canCantinue{
        
        canCantinue = CommonMethod.validateEmptyString(name: txtfldConfirmPassword.text!, withIdentifier: "confirm password")
    }
    return canCantinue
}

func changePasswordApiCall()
{
    
    let tokenString =  UserDefaults.standard.object(forKey:"token") as? String ?? ""
    let parameters = ["password": txtfldOldPassword.text!,"newpassword": txtfldNewPassword.text!,"confirmpassword": txtfldConfirmPassword.text!,"token":tokenString]
    print(parameters)
    SVProgressHUD.show(withStatus: "Loading...")
    SVProgressHUD.setDefaultMaskType(.clear)
    
    ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kChangePassword, parameters: parameters, completion: { (dic) in
        print("Response Data :\n\(dic)")
        let status =  dic.object(forKey: "status") as! NSString
        let message = dic.object(forKey: "message") as! NSString
        if status == "SUCCESS"
        {
            CommonMethod.makeAlert(alertMsg: message as String)
            let settings = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
            self.navigationController?.pushViewController(settings, animated: true)
            
        }else if status == "FAILURE"{
            
            if (message as String) == AppConstants.kAlreadyLoginMsg{
                self.dismiss(animated: false, completion: nil)
                CommonMethod.makeAlertForAlreadyLogin(alertMsg: AppConstants.kAlredyLoginMsgDisplay)
                
            }else{
                
                CommonMethod.makeAlert(alertMsg: message as String)
                
            }
            
        }
    })
    }
}
