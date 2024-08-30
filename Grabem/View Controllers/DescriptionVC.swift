//
//  DescriptionVC.swift
//  Grabem
//
//  Created by Callsoft on 09/05/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import MessageUI
import SVProgressHUD
import CoreLocation


class DescriptionVC: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate  {
  
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var vwMenu: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var lblRestaurantName: UILabel!
    @IBOutlet var btnDistance: UIImageView!
    @IBOutlet var imgCafe: UIImageView!
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet var lblRestaurantType: UILabel!
    @IBOutlet var btnLocation: UIButton!
    @IBOutlet var lblRestraCuisine: UILabel!
    @IBOutlet var lblMenu: UILabel!
    @IBOutlet var lblVehicle: UILabel!
    @IBOutlet var lblRestra: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var mapVC: GMSMapView!
    
    @IBOutlet weak var scanCodeBtn: UIButton!
    
    var locationManager = CLLocationManager()
    var locationMarker : GMSMarker? = GMSMarker()
    var infoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)!.first! as! InfoWindow
    var id = ""
    var distance = ""
    var email = ""
    
    var image1 = ""
    var image2 = ""
    var image3 = ""
    var arrBarImage :NSMutableArray = NSMutableArray()
    var responseDict =  NSDictionary()
    
    let WebserviceConnection =  AlmofireWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanCodeBtn.layer.cornerRadius = scanCodeBtn.frame.size.height/2
        
        restDescriptionApi()
        
        let  mapCenterQuardinateValue =  CLLocationCoordinate2D(latitude: 28.535517, longitude: 77.391029)
        let camera = GMSCameraPosition.camera(withLatitude: mapCenterQuardinateValue.latitude,longitude: mapCenterQuardinateValue.longitude,zoom: 10)
        
        map.camera = camera
        map.animate(to: camera)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DescriptionVC.handleTap(sender:)))
        
        vwMenu.addGestureRecognizer(tap)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       // restDescriptionApi()
        
        super.viewWillAppear(true)
        self.map.isMyLocationEnabled = true
        map.delegate = self
        btnLocation.setTitle(distance, for: UIControlState())
        
    }

    
    @objc func handleTap(sender:UIButton){
        
        if lblMenu.text == "Menu"
        
        {
        let indexPath = IndexPath(item: 1, section: 0)
        
        self.collectionView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        self.pageControl.currentPage = 3
    
        }else if lblMenu.text == "No"
            
        {
            
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    
    @IBAction func tap_scanCodeBtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ScannerVC") as! ScannerVC
        
        vc.restaurantID = id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    func createScrollview(image1:String,image2:String,image3:String){
        
        let arrImg = NSMutableArray()
       
        if image1 != ""{
           
            arrImg.add(image1)
            
        }
      
        if image2 != ""{
            
            arrImg.add(image2)
        }
        
        if image3 != ""{
            
            arrImg.add(image3)
        }
        
        
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:211)
        let scrollViewWidth:Int = Int(self.scrollView.frame.width)
        for i in 0 ..< arrImg.count {
            let imgView = UIImageView(frame: CGRect(x:(scrollViewWidth * i), y:0,width:scrollViewWidth, height:211))
            let url = URL.init(string:arrImg[i] as! String)
            imgView.af_setImage(withURL: url!)

            if url != nil{
                
               imgView.af_setImage(withURL: url!, placeholderImage:UIImage(named:"cafeimg_desc"))
            }
            imgView.contentMode = .scaleToFill
            self.scrollView.addSubview(imgView)
        }
        self.scrollView.isPagingEnabled = true
        pageControl.isHidden = false
        self.scrollView.contentSize = CGSize(width:scrollViewWidth * arrImg.count, height:150)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = arrImg.count
        print(arrImg.count)
        
    }
    
    func  showMarker(lat:String, long:String){
        
        map.clear()
        
        if lat != "" && long != ""
        {
            let position = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
    
            let camera = GMSCameraPosition.camera(withLatitude: position.latitude,longitude: position.longitude,zoom: 15)
            map.camera = camera
            map.animate(to: camera)
            
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "logo_location")
            marker.accessibilityLabel  = String(1)
            marker.map = map
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCallAction(_ sender: Any) {
        
        let phoneNo = UserDefaults.standard.string(forKey: "phone") ?? ""
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNo)"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(phoneCallURL)
            }
        }
        
    }
    
    @IBAction func btnLocationAction(_ sender: Any) {
        
        
    }
    
  
    
    @IBAction func btnSendMailAction(_ sender: Any) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
        self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    @IBAction func btnMilesTapped(_ sender: Any) {
        
        let vc  =  self.storyboard?.instantiateViewController(withIdentifier:"LocationVc") as? LocationVc
        
        vc?.TotalObject = self.responseDict
        vc?.iscoming =  false
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([email])
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        // Test the offset and calculate the current page after scrolling ends
        
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0
        {
            
        }
        else if Int(currentPage) == 1
        {
        }
        else if Int(currentPage) == 2
        {
        }
        else
        {
            
        }
    }
    
    
    func  restDescriptionApi(){
        
        let parameters = ["id": id]
        print(parameters)
        
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(.clear)
        
        ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.krestDescription, parameters: parameters, completion: { (dic) in
            print("Response Data :\n\(dic)")
            
            
            let status =  dic.object(forKey: "status") as! NSString
            let message = dic.object(forKey: "message") as! NSString
            if status == "SUCCESS"
            {
                self.responseDict = (dic.object(forKey: "RestDescription") as? NSDictionary)!
                //{
                    _ = self.responseDict.object(forKey: "id") as? String ?? ""
                    let restaurantName = self.responseDict.object(forKey: "name") as? String ?? ""
                    let restaurantType = self.responseDict.object(forKey: "type") as? String ?? ""
                        let restaurantCuisine = self.responseDict.object(forKey: "cuisine") as? String ?? ""
                    let city = self.responseDict.object(forKey: "city") as? String ?? ""
                    let state = self.responseDict.object(forKey: "state") as? String ?? ""
                    let country = self.responseDict.object(forKey: "country") as? String ?? ""
                    let pincode = self.responseDict.object(forKey: "pin_code") as? String ?? ""
                    let restaurantDiscount = self.responseDict.object(forKey: "discount") as? String ?? ""
                    let phoneNo = self.responseDict.object(forKey: "phone") as? String ?? ""
                     self.image1 = self.responseDict.object(forKey: "image1") as? String ?? ""
                     self.image2 = self.responseDict.object(forKey: "image2") as? String ?? ""
                
                    self.image3 = self.responseDict.object(forKey: "image3") as? String ?? ""
                
                    _ = self.responseDict.object(forKey: "description1") as? String ?? ""
                    _ = self.responseDict.object(forKey: "description2") as? String ?? ""
                    let sittingValue = self.responseDict.object(forKey: "sitting") as? String ?? ""
                    let deliveryValue = self.responseDict.object(forKey: "delivery") as? String ?? ""
                    let menuValue = self.responseDict.object(forKey: "menu") as? String ?? ""
                    let lat = self.responseDict.object(forKey: "lat") as? String ?? ""
                    let long = self.responseDict.object(forKey: "log") as? String ?? ""
                    
                   
                  
                    if self.image1 != "" {
                        
                        self.arrBarImage.add(self.image1)
                    }
                    
                    if self.image2 != "" {
                        
                        self.arrBarImage.add(self.image2)
                    }
                if self.image3 != "" {
                    
                    self.arrBarImage.add(self.image3)
                }
                
                print(self.arrBarImage.count)
                    
                    self.collectionView.reloadData()
                    
                    if menuValue == "0" {
                        
                        self.lblMenu.text = "No"
                        

                    }else {
                        
                        self.lblMenu.text = "Menu"
                        
                    }
                    
                    if deliveryValue == "0"{
                        
                        self.lblVehicle.text = "No"
                        
                        
                    }else {
                        
                       
                        self.lblVehicle.text = "Yes"
                        
                    }
                    
                    if sittingValue == "0"{
                        
                      self.lblRestra.text = "No"
                        
                    }else {
                        
                        self.lblRestra.text = "Yes"
                        
                    }
                    
                    UserDefaults.standard.set(phoneNo, forKey: "phone")
                    self.lblRestaurantName.text! = restaurantName
                    self.lblRestaurantType.text! = restaurantCuisine
                    self.lblRestraCuisine.text! = city + ", " +  state + ", " + country + ", " + pincode
                    self.lblDiscount.text! = restaurantDiscount + "% off for GRABEM users"
//                    self.createScrollview(image1:self.image1,image2:self.image2,image3:self.image3)
                    self.showMarker(lat: lat, long: long)
                    //self.getDistance(lat: lat, long: long)

            //}
                
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
    
}




extension DescriptionVC: GMSMapViewDelegate  {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        return true
        
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
        
        
        
    }
    
    func sizeForOffset(view: UIView) -> CGFloat {
        
        return  130
        
    }
    
    func sizeForOffsetX(view: UIView) -> CGFloat{
        
        return 110
        
    }
    
}

extension DescriptionVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout  {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrBarImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellDescrptn
        
        
        
        let url = URL.init(string:arrBarImage[indexPath.row] as? String ?? "")
        cell.imgBar.af_setImage(withURL: url!)
        
        if url != nil{
            
            cell.imgBar.af_setImage(withURL: url!, placeholderImage:UIImage(named:"cafeimg_desc"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.layer.frame.size.width, height: collectionView.layer.frame.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.collectionView {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        } else {
            
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
    }
    
}


