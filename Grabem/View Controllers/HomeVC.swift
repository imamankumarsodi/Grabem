//
//  HomeVC.swift
//  Grabem
//
//  Created by Callsoft on 10/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet var lblUniqueUserId: UILabel!
    
    @IBOutlet weak var btnScannedRestaurant: UIButton!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self,selector: #selector(showLogin),name: NSNotification.Name(rawValue: "showLogin"),object: nil)
        
        lblUniqueUserId.text = UserDefaults.standard.string(forKey: "unique_user_id") ?? ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSettingsAction(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "typeChecker") as! String == "skip"{
            
            let alertController = UIAlertController(title: "", message: "Please login first.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
            }
            let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let setting = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
            self.navigationController?.pushViewController(setting, animated: true)
        }
        
    }
    
    @objc func showLogin(notif: NSNotification) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as? LogInVC
        let navController = UINavigationController(rootViewController: vc!)
        navController.navigationBar.isHidden = true
        self.present(navController, animated: false, completion: nil)
        
    }
    
    @IBAction func tap_scannedRestaurantBtn(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "typeChecker") as! String == "skip"{
            
            let alertController = UIAlertController(title: "", message: "Please login first.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
            }
            let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "VisitedRestaurantListVC") as! VisitedRestaurantListVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }

}
