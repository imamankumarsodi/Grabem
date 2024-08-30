//
//  ContactVC.swift
//  Grabem
//
//  Created by Callsoft on 10/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import SVProgressHUD

class ContactVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var txtfldFullName: UITextField!
    @IBOutlet var txtfldEmailId: UITextField!
    @IBOutlet var txtfldPhoneNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "   Complaint/Comments"
        textView.textColor = UIColor.darkGray
        textView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = nil
            textView.textColor = UIColor.darkGray
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        
            if textView.text.isEmpty {

                textView.text = "   Complaint/Comments"
          }

    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        if canContinue(){
            
            contactApiCall()
            
        }
    }
    
    @IBAction func btnSettingsAction(_ sender: Any) {
    }
    
    @IBAction func btnSharingAction(_ sender: Any) {
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

        return canCantinue
    }

    func contactApiCall()
    {
        
        let parameters = ["fullname": txtfldFullName.text!,"email": txtfldEmailId.text!,"phone":txtfldPhoneNo.text!,"comments":textView.text!]
        print(parameters)
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(.clear)
        
        ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kUserContact, parameters: parameters, completion: { (dic) in
            print("Response Data :\n\(dic)")
            let status =  dic.object(forKey: "status") as! NSString
            let message = dic.object(forKey: "message") as! NSString
            if status == "SUCCESS" {
                
                self.txtfldFullName.text = ""
                self.txtfldEmailId.text = ""
                self.txtfldPhoneNo.text = ""
                self.textView.text = "   Complaint/Comments"
                self.textView.textColor = UIColor.darkGray
                
                CommonMethod.makeAlert(alertMsg: "Thanks for contacting us!")
           
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
