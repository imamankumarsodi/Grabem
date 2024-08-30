//
//  MapVC.swift
//  Travolong
//
//  Created by callsoft on 09/11/17.
//  Copyright © 2017 callsoft. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import MessageUI
import IQKeyboardManagerSwift


class MapVC: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet var searchView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    let placeholderWidth = 160
    var offset = UIOffset()
    var responseArrList = [RestaurantListObject]()
    @IBOutlet weak var map: GMSMapView!
    var locationManager = CLLocationManager()
    var locationMarker : GMSMarker? = GMSMarker()
    var infoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)!.first! as! InfoWindow
    var typechecker = ""
    var emailIndex = 0
    
    var getlatitude:CLLocationDegrees = CLLocationDegrees()
    var getlongitude:CLLocationDegrees = CLLocationDegrees()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        //::::::::::::::::
        getCurrentLocation()
        
        infoWindow.imgRestaurant.layer.cornerRadius = 5
        infoWindow.imgRestaurant.clipsToBounds = true
        
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

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewRestaurantListApi(pincode: searchBar.text!)
        print(searchBar.text!)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //let noOffset = UIOffset(horizontal: 0, vertical: 0)
       // searchBar.setPositionAdjustment(noOffset, for: .search)
        
        return true
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
       // searchBar.setPositionAdjustment(offset, for: .search)
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        let camera = GMSCameraPosition.camera(withLatitude: getlatitude, longitude: getlongitude, zoom: 14.0)
        map.camera = camera
        
        self.locationManager.distanceFilter = 15.0;
        
        viewRestaurantListApi(pincode: "")
        
    }
    
    
    ///location manager setup
    
    func getCurrentLocation(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
            locationManager.requestWhenInUseAuthorization()
            self.locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
            
        } else {
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        self.getlatitude = location[0].coordinate.latitude
        self.getlongitude = location[0].coordinate.longitude

        let camera = GMSCameraPosition.camera(withLatitude: getlatitude, longitude: getlongitude, zoom: 14.0)
        map.camera = camera
        
        self.locationManager.distanceFilter = 15.0;
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            
            
        }
    }
    
    //:::::::::::::::::::::
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true
        )
        searchBar.delegate = self
        self.map.isMyLocationEnabled = true
        map.delegate = self
        
        viewRestaurantListApi(pincode: "")

        
    }
    @IBAction func btnListAction(_ sender: Any) {
        
        let otpObjVC = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        self.navigationController?.pushViewController(otpObjVC, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
   
    func  showMarker(withOutPincode : Bool)
    {
    
        map.clear()
        
        var i = 0

        for element in responseArrList {
            
            
            let lat = element.lat ?? ""
            let long = element.long ?? ""
            
            let position = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "logo_location")
            marker.accessibilityLabel  = String(i)
            i = i + 1
            marker.map = map
    
        }
        
        if responseArrList.count > 0{
            
            let lat = responseArrList[0].lat ?? ""
            let long =  responseArrList[0].long ?? ""
            
            if !withOutPincode
            {
                print(getlatitude)
                      let   mapCenterQuardinateValue =  CLLocationCoordinate2D(latitude:getlatitude, longitude: getlongitude)
                                let camera = GMSCameraPosition.camera(withLatitude: mapCenterQuardinateValue.latitude,longitude: mapCenterQuardinateValue.longitude,zoom: 10)
                                map.camera = camera
                                map.animate(to: camera)
            }
            else
            {
                                let   mapCenterQuardinateValue =  CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
                                let camera = GMSCameraPosition.camera(withLatitude: mapCenterQuardinateValue.latitude,longitude: mapCenterQuardinateValue.longitude,zoom: 10)
                                map.camera = camera
                                map.animate(to: camera)
            }
            
//            if lat != "" && long != "" {
//
//                let   mapCenterQuardinateValue =  CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
//                let camera = GMSCameraPosition.camera(withLatitude: mapCenterQuardinateValue.latitude,longitude: mapCenterQuardinateValue.longitude,zoom: 15)
//                map.camera = camera
//                map.animate(to: camera)
//
//            }else{
//
//                let   mapCenterQuardinateValue =  CLLocationCoordinate2D(latitude:CommonMethod.appDelegate().getlatitude, longitude: CommonMethod.appDelegate().getlongitude)
//                let camera = GMSCameraPosition.camera(withLatitude: mapCenterQuardinateValue.latitude,longitude: mapCenterQuardinateValue.longitude,zoom: 15)
//                map.camera = camera
//                map.animate(to: camera)
//            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
 
    func viewRestaurantListApi(pincode:String){
    
    map.clear()
    self.responseArrList.removeAll()
    let tokenString =  UserDefaults.standard.object(forKey:"token") as? String ?? ""
    let parameters = ["pin_code":pincode,"token":tokenString]
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
                    
                    let restaurantData = RestaurantListObject(id:resataurantId,name: restaurantName, type: restaurantType, cuisine: restaurantCuisine, city: restaurantCity, state: restaurantState, country: restaurantCountry, pin_code: restaurantPincode, discount: restaurantDiscount, phone: restaurantPhone,email:restaurantEmail, image1: restaurantImage1, image2: restaurantImage2, description1: restaurantDescription1, description2: restaurantDescription2, sitting: restaurantSitting, delivery: restaurantDelivery, menu: restaurantMenu, lat:restaurantLatitude, long:restaurantLongitude,mile:mile)
                    
                    self.responseArrList.append(restaurantData)
                    
                }
                
                if pincode == ""
                {
                  self.showMarker(withOutPincode: false)
                }
                else
                {
                    self.showMarker(withOutPincode: true)
                }

            }
            
        }else if status == "FAILURE"
        {
            if (message as String) == AppConstants.kAlreadyLoginMsg{
                CommonMethod.makeAlertForAlreadyLogin(alertMsg: AppConstants.kAlredyLoginMsgDisplay)
                
            }else{
                
                CommonMethod.makeAlert(alertMsg: message as String)
                
            }
            
        }
    })
  }
}


extension MapVC: GMSMapViewDelegate  {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        let index:Int! = Int(marker.accessibilityLabel!)
        
        let markerData = responseArrList[index]
        print(markerData)
        
        locationMarker = marker
        guard let location = locationMarker?.position else {
            
        
            
            return false
        }
        
        var myString:NSString = " (Cafe)"
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: markerData.name!, attributes: [NSAttributedStringKey.font:UIFont(name: "Helvetica", size: 16.0)!])
        
        let  myMutableString1 = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Helvetica", size: 10.0)!])
        
        myMutableString1.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:7))
        let combination = NSMutableAttributedString()
        
        combination.append(myMutableString)
        combination.append(myMutableString1)
        infoWindow.lblRestaurantName.attributedText = combination
        
        
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow) + 10
        infoWindow.center.x = infoWindow.center.x + 45.0
        infoWindow.btnTap.tag = index
        infoWindow.btnTap.addTarget(self, action: #selector(MapVC.handleTap(sender:)), for: .touchUpInside)
        infoWindow.btnCall.tag = index
        infoWindow.btnMail.tag = index
        
        infoWindow.lblRestaurantCuisine.text = markerData.cuisine
        infoWindow.lblRestaurantLocation.text = markerData.city! +  markerData.state! + markerData.country!
        infoWindow.lblDiscount.text = markerData.discount! + "% off for GRABEM user"
        infoWindow.btnCall.addTarget(self, action: #selector(MapVC.handleCall(sender:)), for: .touchUpInside)
        infoWindow.btnMail.addTarget(self, action: #selector(MapVC.handleMail(sender:)), for: .touchUpInside)
        self.map.addSubview(infoWindow)
        let url1 = URL(string: markerData.image1!)
        
        if url1 != nil{
            
            infoWindow.imgRestaurant.af_setImage(withURL: url1!, placeholderImage:UIImage(named:"cafeimg_desc"))
            
        }else{
            
            infoWindow.imgRestaurant.image = UIImage(named:"cafeimg_desc")
        }
       
        return true

    }
    
     @objc func handleTap(sender:UIButton){
       
       let tag = sender.tag
        let objTabBar = self.storyboard?.instantiateViewController(withIdentifier: "DescriptionVC") as! DescriptionVC
        
        objTabBar.id = responseArrList[sender.tag].id!
        
        objTabBar.distance =  "\(getDistance(lat: responseArrList[sender.tag].lat!, long: responseArrList[sender.tag].long!)) Miles"
        
        self.navigationController?.pushViewController(objTabBar, animated: true)

    }
    
    
    func getDistance(lat:String,long:String) -> String
    {
        
        var myLocation = CLLocation(latitude: CommonMethod.appDelegate().getlatitude, longitude: CommonMethod.appDelegate().getlongitude)
        var myBuddysLocation = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
        var distance = myLocation.distance(from: myBuddysLocation) / 1.60934
        print(distance)
        let myBuddysLocation1 = String(format: "%.1f", distance)
        
        let disString = String(describing: myBuddysLocation1)
        if disString == "" || disString.isEmpty {
            return ""
        }else {
            
            return disString
        }
        return ""
        
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
    
    @objc func handleMail(sender:UIButton){
        
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
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        infoWindow.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                return
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow) + 10
            infoWindow.center.x = infoWindow.center.x - 44
        } 
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
            let index:Int! = Int(marker.accessibilityLabel!)
            
            let infoWindowData = responseArrList [index]
            print(infoWindowData)
        }
    
    func sizeForOffset(view: UIView) -> CGFloat {
        
        return  130
        
    }
    
    func sizeForOffsetX(view: UIView) -> CGFloat{
        
        return 110
 
    }
    
}


