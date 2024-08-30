//
//  LocationVc.swift
//  Grabem
//
//  Created by callsoft on 08/08/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class LocationVc: UIViewController,CLLocationManagerDelegate {
    
    
    @IBOutlet var mapview: GMSMapView!
    
    
    //VARIABLES
    
    var locationManager = CLLocationManager()
    var locationMarker : GMSMarker? = GMSMarker()
    var getlatitude:CLLocationDegrees = CLLocationDegrees()
    var getlongitude:CLLocationDegrees = CLLocationDegrees()
    var TotalObject =  NSDictionary()
    var iscoming = Bool()
    
    var listLatitude =  String()
    var listLongitude =  String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
         getCurrentLocation()
    
        setRetursntLocationOnMap()
        
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
        
        let camera = GMSCameraPosition.camera(withLatitude: getlatitude, longitude: getlongitude, zoom: 0.0)
        mapview.camera = camera
        
        let position = CLLocationCoordinate2D(latitude: Double(self.getlatitude), longitude: Double(self.getlongitude))
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "logo_location")
        marker.map = mapview

        
        self.locationManager.distanceFilter = 15.0;
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            
            
        }
    }
    
    
    func setRetursntLocationOnMap(){
        
        if iscoming ==  false {
            
            print("ASDFGHJKL")
            
            print(TotalObject)
            
            let latitude  = self.TotalObject.value(forKey: "lat") as? String
            let longitude  = self.TotalObject.value(forKey: "log") as? String
            
            var lat =  Double()
            var long =  Double()
            
            lat = (NumberFormatter().number(from: latitude!)?.doubleValue)!
            long = (NumberFormatter().number(from: longitude!)?.doubleValue)!
            
            
            print("My double LATITUDE: \(lat)")
            print("My double LOGITUDE: \(long)")
            
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let camera = GMSCameraPosition.camera(withLatitude: position.latitude,longitude: position.longitude,zoom: 0.0)
            mapview.camera = camera
            mapview.animate(to: camera)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "logo_location")
            marker.map = mapview
            
            print("ASDFGHJKL")
            
        }else{
            
            var lat =  Double()
            var long =  Double()
            
            lat = (NumberFormatter().number(from: listLatitude)?.doubleValue)!
            long = (NumberFormatter().number(from: listLongitude)?.doubleValue)!
            
            print("My double LATITUDE: \(lat)")
            print("My double LOGITUDE: \(long)")

            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)

            let camera = GMSCameraPosition.camera(withLatitude: position.latitude,longitude: position.longitude,zoom: 0.0)
            mapview.camera = camera
            mapview.animate(to: camera)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "logo_location")
            marker.map = mapview
            
            
        }

       
        
        
    }
    
    
    // ACTIONS
    
    @IBAction func btnBAckTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
