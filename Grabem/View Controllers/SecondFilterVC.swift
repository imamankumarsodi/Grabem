//
//  SecondFilterVC.swift
//  Grabem
//
//  Created by Callsoft on 10/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import CoreLocation


class SecondFilterVC: UIViewController {
    
    @IBOutlet var btnSlider: UISlider!
    @IBOutlet var txtfldLocation: UITextField!
    @IBOutlet var txtfldPostCode: UITextField!
    @IBOutlet var lblPercentage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    
    @IBAction func btnApplyAction(_ sender: Any) {
        
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "filterDataForHappening"), object: nil, userInfo : ["data" : [self.txtfldPostCode.text!,self.txtfldLocation.text!,String(Int(btnSlider.value))]])
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnCancelAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnLocationAction(_ sender: Any) {
        
        
    }
    
    
    @IBAction func btnSliderAction(_ sender: Any) {
        
        lblPercentage.text = String(Int(btnSlider.value))
        
    }
    
    @objc func showList(notif: NSNotification) {
        
        
    }
    
}
