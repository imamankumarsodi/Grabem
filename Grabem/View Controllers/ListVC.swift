//
//  ListVC.swift
//  Redbean
//
//  Created by callsoft on 13/04/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import MessageUI
import CoreLocation

class ListVC: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var listTableView: UITableView!
    let placeholderWidth = 160
    var offset = UIOffset()
    let restaurantNameArr = ["Spicy Bar (Cafe)","Gordan Ramsey (Cafe)","Jamie Oliver (Cafe)"]
    let imgArr = ["img_a","img_b","img_c"]
    var responseArrList = [RestaurantListObject]()
    
    var emailIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewRestaurantListApi(pincode: "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(filterDataForHappening), name: NSNotification.Name(rawValue: "filterDataForHappening"), object: nil)

        let position = CLLocationCoordinate2D(latitude: Double(31.2304), longitude: Double(121.4737))
        
        CommonMethod.getCurrentCity(lat: position.latitude, long: position.longitude)
        
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.tintColor = UIColor.gray
        searchBar.backgroundImage = UIImage()
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.layer.cornerRadius = 0.0
                    textField.backgroundColor = UIColor.clear
                }
            }
        }
    
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.layer.cornerRadius = 0.0
                    textField.backgroundColor = UIColor.clear                    
                }
                
            }
        }
  
    }
    
    @objc func filterDataForHappening(notif: NSNotification) {
        
        let value =  notif.userInfo?["data"] as! NSArray
        
        let pincode = value[0] as? String ?? ""
        let location = value[1] as? String ?? ""
        let slider = value[2] as? String ?? ""
        filterApiCall(pincode: pincode, city: location, slider: slider)
          print(value)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewRestaurantListApi(pincode: searchBar.text!)
        print(searchBar.text!)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let noOffset = UIOffset(horizontal: 0, vertical: 0)
      //  searchBar.setPositionAdjustment(noOffset, for: .search)
        
        return true
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
     //   searchBar.setPositionAdjustment(offset, for: .search)
        
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func btnListAction(_ sender: Any) {
        
    
        let sendPeepVCObj = self.storyboard?.instantiateViewController(withIdentifier: "SecondFilterVC") as! SecondFilterVC
        self.navigationController?.pushViewController(sendPeepVCObj, animated: true)
        
    }
    
    
    @objc func btnMilesTapped(sender:UIButton) {
        
        let vc  =  self.storyboard?.instantiateViewController(withIdentifier:"LocationVc") as? LocationVc
        
        let tag =  sender .tag
        
         let restaurantData = responseArrList[tag]
    
        vc?.listLatitude = restaurantData.lat!
        vc?.listLongitude = restaurantData.long!
        vc?.iscoming =  true
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @objc func handleCall(sender:UIButton){
        
        let phoneNo = UserDefaults.standard.string(forKey: "phone") ?? ""
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNo)"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(phoneCallURL)
            }
        }
        
    }
    
    @objc func handleMail(sender:UIButton)
    {
        emailIndex = sender.tag
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }

    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([responseArrList[emailIndex].email!])
        mailComposerVC.setSubject("Order from Grabem:")
        let userid = UserDefaults.standard.string(forKey: "unique_user_id") ?? ""
        mailComposerVC.setMessageBody("My Grabem ID is \(userid)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func mailFunc()   {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func filterApiCall(pincode:String, city : String, slider : String){
        
        self.responseArrList.removeAll()
        let tokenString =  UserDefaults.standard.object(forKey:"token") as? String ?? ""
        let parameters = ["pin_code":pincode,
                          "token":tokenString,
                          "city":city,
                          "slider":slider,
                          "clat":CommonMethod.appDelegate().getlatitude,
                          "clong":CommonMethod.appDelegate().getlongitude] as [String : Any]
        print(parameters)
        ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kViewRestaurantList, parameters: parameters, completion: { (dic) in
            print("Response Data :\n\(dic)")
            let status =  dic.object(forKey: "status") as! NSString
            let message = dic.object(forKey: "message") as! NSString
            if status == "SUCCESS"
            {
                
                if let responseArry = dic.object(forKey: "Restaurant_list") as? NSArray{
                    
                    for element in responseArry {
                        
                        let resataurantId = (element as! NSDictionary).object(forKey: "id") as? String ?? ""
                        let restaurantName = (element as! NSDictionary).object(forKey: "name") as? String ?? ""
                        let restaurantType = (element as! NSDictionary).object(forKey: "type") as? String ?? ""
                        let restaurantCuisine = (element as! NSDictionary).object(forKey: "cuisine") as? String ?? ""
                        let restaurantCity = (element as! NSDictionary).object(forKey: "city") as? String ?? ""
                        let restaurantState = (element as! NSDictionary).object(forKey: "state") as? String ?? ""
                        let restaurantCountry = (element as! NSDictionary).object(forKey: "country") as? String ?? ""
                        let restaurantPincode = (element as! NSDictionary).object(forKey: "pin_code") as? String ?? ""
                        let restaurantDiscount = (element as! NSDictionary).object(forKey: "discount") as? String ?? ""
                        let restaurantPhone = (element as! NSDictionary).object(forKey: "phone") as? String ?? ""
                        let restaurantEmail = (element as! NSDictionary).object(forKey: "email") as? String ?? ""
                        let restaurantImage1 = (element as! NSDictionary).object(forKey: "image1") as? String ?? ""
                        let restaurantImage2 = (element as! NSDictionary).object(forKey: "image2") as? String ?? ""
                        let restaurantDescription1 = (element as! NSDictionary).object(forKey: "description1") as? String ?? ""
                        let restaurantDescription2 = (element as! NSDictionary).object(forKey: "description2") as? String ?? ""
                        let restaurantSitting = (element as! NSDictionary).object(forKey: "sitting") as? String ?? ""
                        let restaurantDelivery = (element as! NSDictionary).object(forKey: "delivery") as? String ?? ""
                        let restaurantMenu = (element as! NSDictionary).object(forKey: "menu") as? String ?? ""
                        let restaurantLatitude = (element as! NSDictionary).object(forKey: "lat") as? String ?? ""
                        let restaurantLongitude = (element as! NSDictionary).object(forKey: "log") as? String ?? ""
                        let mile = (element as! NSDictionary).object(forKey: "mile") as? String ?? ""

                        
                        let restaurantData = RestaurantListObject(id:resataurantId, name: restaurantName, type: restaurantType, cuisine: restaurantCuisine, city: restaurantCity, state: restaurantState, country: restaurantCountry, pin_code: restaurantPincode, discount: restaurantDiscount, phone: restaurantPhone, email:restaurantEmail ,image1: restaurantImage1, image2: restaurantImage2, description1: restaurantDescription1, description2: restaurantDescription2, sitting: restaurantSitting, delivery: restaurantDelivery, menu: restaurantMenu, lat:restaurantLatitude, long:restaurantLongitude,mile:mile)
                        
                        self.responseArrList.append(restaurantData)
                        
                    }
                    
                }
                
                self.listTableView.isHidden = false
                self.listTableView.reloadData()
                
            }else if status == "FAILURE"
            {
                self.listTableView.isHidden = false
                self.listTableView.reloadData()
                
                if (message as String) == AppConstants.kAlreadyLoginMsg{
                    self.dismiss(animated: false, completion: nil)
                    CommonMethod.makeAlertForAlreadyLogin(alertMsg: AppConstants.kAlredyLoginMsgDisplay)
                    
                }else{
                    
                    CommonMethod.makeAlert(alertMsg: message as String)
                    
                }
                
            }
        })
        
    }
    
    func viewRestaurantListApi(pincode:String){
        
        self.responseArrList.removeAll()
        let tokenString =  UserDefaults.standard.object(forKey:"token") as? String ?? ""
        let parameters = ["pin_code":pincode,
                          "token":tokenString,
                          "clat":CommonMethod.appDelegate().getlatitude,
                          "clong":CommonMethod.appDelegate().getlongitude] as [String : Any]
        
        print(parameters)
        
        ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kViewRestaurantList, parameters: parameters as? [String : Any] as? [String : Any], completion: { (dic) in
            print("Response Data :\n\(dic)")
            let status =  dic.object(forKey: "status") as! NSString
            let message = dic.object(forKey: "message") as! NSString
            if status == "SUCCESS"
            {
                
                if let responseArry = dic.object(forKey: "Restaurant_list") as? NSArray{
                    
                    print("RARARARRAARAR")
                    print(responseArry)
                    print("RARARARRAARAR")
                    
                    for element in responseArry {
                        
                let resataurantId = (element as! NSDictionary).object(forKey: "id") as? String ?? ""
                let restaurantName = (element as! NSDictionary).object(forKey: "name") as? String ?? ""
                let restaurantType = (element as! NSDictionary).object(forKey: "type") as? String ?? ""
                let restaurantCuisine = (element as! NSDictionary).object(forKey: "cuisine") as? String ?? ""
                let restaurantCity = (element as! NSDictionary).object(forKey: "city") as? String ?? ""
                let restaurantState = (element as! NSDictionary).object(forKey: "state") as? String ?? ""
                let restaurantCountry = (element as! NSDictionary).object(forKey: "country") as? String ?? ""
                let restaurantPincode = (element as! NSDictionary).object(forKey: "pin_code") as? String ?? ""
                let restaurantDiscount = (element as! NSDictionary).object(forKey: "discount") as? String ?? ""
                let restaurantPhone = (element as! NSDictionary).object(forKey: "phone") as? String ?? ""
                let restaurantEmail = (element as! NSDictionary).object(forKey: "email") as? String ?? ""
                let restaurantImage1 = (element as! NSDictionary).object(forKey: "image1") as? String ?? ""
                let restaurantImage2 = (element as! NSDictionary).object(forKey: "image2") as? String ?? ""
                let restaurantDescription1 = (element as! NSDictionary).object(forKey: "description1") as? String ?? ""
                let restaurantDescription2 = (element as! NSDictionary).object(forKey: "description2") as? String ?? ""
                let restaurantSitting = (element as! NSDictionary).object(forKey: "sitting") as? String ?? ""
                let restaurantDelivery = (element as! NSDictionary).object(forKey: "delivery") as? String ?? ""
                let restaurantMenu = (element as! NSDictionary).object(forKey: "menu") as? String ?? ""
                let restaurantLatitude = (element as! NSDictionary).object(forKey: "lat") as? String ?? ""
                let restaurantLongitude = (element as! NSDictionary).object(forKey: "log") as? String ?? ""
                let mile = (element as! NSDictionary).object(forKey: "mile") as? String ?? ""

                        let restaurantData = RestaurantListObject(id:resataurantId, name: restaurantName, type: restaurantType, cuisine: restaurantCuisine, city: restaurantCity, state: restaurantState, country: restaurantCountry, pin_code: restaurantPincode, discount: restaurantDiscount, phone: restaurantPhone,email:restaurantEmail, image1: restaurantImage1, image2: restaurantImage2, description1: restaurantDescription1, description2: restaurantDescription2, sitting: restaurantSitting, delivery: restaurantDelivery, menu: restaurantMenu, lat:restaurantLatitude, long:restaurantLongitude,mile:mile)
                        
                self.responseArrList.append(restaurantData)

                    }
                    
                }
                
                self.listTableView.isHidden = false
                self.listTableView.reloadData()
                
            }else if status == "FAILURE"
            {
                self.listTableView.isHidden = false
                self.listTableView.reloadData()
                
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

extension ListVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return responseArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell

        let restaurantData = responseArrList[indexPath.row]
    
        cell?.lblFoodType.text = restaurantData.cuisine
        cell?.lblLocation.text = restaurantData.city! + ", " +  restaurantData.state! + ", " +  restaurantData.country! + ", " + restaurantData.pin_code!
        cell?.lblDiscount.text = restaurantData.discount! + "% off for GRABEM user"
        
        let distance = restaurantData.mile
        
        if distance  == "" {
            
            cell?.btnDistance.setTitle("N.A", for: .normal)
            
        }else{
            
            cell?.btnDistance.setTitle(distance, for: .normal)
        }
        

        cell?.btnCall.tag = indexPath.row
        cell?.btnMail.tag = indexPath.row
        cell?.btnCall.addTarget(self, action: #selector(ListVC.handleCall(sender:)), for: .touchUpInside)
        cell?.btnMail.addTarget(self, action: #selector(ListVC.handleMail(sender:)), for: .touchUpInside)
        cell?.btnDistance.addTarget(self, action: #selector(ListVC.btnMilesTapped(sender:)), for: .touchUpInside)
        
        cell?.btnDistance.tag = indexPath.row
        
        let url1 = URL(string: restaurantData.image1!)
        
        if url1 != nil{
            
            cell?.imgRestraunt.af_setImage(withURL: url1!, placeholderImage:UIImage(named:"cafeimg_desc"))
            
        }else{
            
            cell?.imgRestraunt.image = UIImage(named:"cafeimg_desc")
        }
        
        if (indexPath.row == restaurantNameArr.count - 1)
        {
            
            cell?.imgSeperator.isHidden = true
            
        }
        
        var myMutableString = NSMutableAttributedString()
        var myMutableString1 = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: restaurantData.name!, attributes: [NSAttributedStringKey.font:UIFont(name: "Helvetica", size: 16.0)!])
        
        myMutableString1 = NSMutableAttributedString(string: " (\(restaurantData.type!))", attributes: [NSAttributedStringKey.font:UIFont(name: "Helvetica", size: 10.0)!])

        myMutableString1.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:((restaurantData.type?.count)! + 3)))
        let combination = NSMutableAttributedString()
     
        combination.append(myMutableString)
        combination.append(myMutableString1)
        cell?.lblRestrauntName.attributedText = combination
        
        
        let lat = restaurantData.lat
        let long = restaurantData.long
        
        let ResturantLat  = NumberFormatter().number(from: lat!)?.doubleValue
        let ResturantLong  = NumberFormatter().number(from: long!)?.doubleValue
        
        UserDefaults.standard.set(ResturantLat, forKey: "ResturantLat")
        UserDefaults.standard.set(ResturantLong, forKey: "ResturantLong")
        
        //getDistance(lat: lat!, long: long!, button: (cell?.btnDistance)!)
        
        return cell!
        
    }
    
    
//    func getDistance(lat:String,long:String,button :UIButton){
//
//        var myLocation = CLLocation(latitude: CommonMethod.appDelegate().getlatitude, longitude: CommonMethod.appDelegate().getlongitude)
//        var myBuddysLocation = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
//        var distance = myLocation.distance(from: myBuddysLocation) / 1609.344
//
//        //1609.344
//        //1.60934
//
//
//        print(distance)
//
////        var myBuddysLocation = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
////        var distance = myLocation.distance(from: myBuddysLocation) / 1000
//
//        //1609.344
//        //1609.344
//        print("LOCATION")
//        print(myLocation)
//        print(myBuddysLocation)
//        print("LOCATION")
//
//
//        let myBuddysLocation1 = String(format: "%.1f", distance)
//
//        let disString = String(describing: myBuddysLocation1)
//        if disString == "" || disString.isEmpty {
//
//        }else {
//
//
//            button.setTitle("\(disString) Miles", for: .normal)
//        }
//
//
//
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sendPeepVCObj = self.storyboard?.instantiateViewController(withIdentifier: "DescriptionVC") as! DescriptionVC
        
        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! ListTableViewCell
 
        sendPeepVCObj.id = responseArrList[indexPath.row].id!
        sendPeepVCObj.distance = (cell.btnDistance.titleLabel?.text)!
        sendPeepVCObj.email = responseArrList[indexPath.row].email!
        
        self.navigationController?.pushViewController(sendPeepVCObj, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130
    }
    
}

