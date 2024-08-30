//
//  ForgotPasswordVC.swift
//  Grabem
//
//  Created by callsoft on 08/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet var txtfldEmailId: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnResetPasswordAction(_ sender: Any) {
        
        if canContinue(){
            
            forgotPasswordApiCall()

        }

    }
    
    func canContinue() ->Bool{
        
        var canCantinue:Bool = true
        
        
        if canCantinue{
            
            canCantinue = CommonMethod.validateEmailWithString(email: txtfldEmailId.text!, withIdentifier: "email")
        }
        
        return canCantinue
    }
    
    func forgotPasswordApiCall(){
        
        let parameters = ["email":txtfldEmailId.text!]
         ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kForgotPassword, parameters: parameters, completion: { (dic) in
            
            print("Response Data :\n\(dic)")
            let status =  dic.object(forKey: "status") as! NSString
            let message = dic.object(forKey: "message") as! NSString
            if status == "SUCCESS"{

                        let alertController = UIAlertController(title: "", message: "Password has been send to your email", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                           
                            self.navigationController?.popViewController(animated: true)
                        }

                        
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)

                
            } else if status == "FAILURE"{
                
                
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
