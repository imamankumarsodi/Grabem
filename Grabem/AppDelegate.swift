//
//  AppDelegate.swift
//  Grabem
//
//  Created by callsoft on 07/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import FBSDKLoginKit
import FBSDKCoreKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var getlatitude:CLLocationDegrees = CLLocationDegrees()
    var getlongitude:CLLocationDegrees = CLLocationDegrees()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Thread.sleep(forTimeInterval: 3.0)
                GMSServices.provideAPIKey("AIzaSyC7atqt6xIM_V_DYJ6rDLdstJnkptdsiCc")
                GMSPlacesClient.provideAPIKey("AIzaSyC7atqt6xIM_V_DYJ6rDLdstJnkptdsiCc")
//        GMSServices.provideAPIKey("AIzaSyB9RhLAU9DdBo94k3JAwecdkQUWxRFKnU8")
//        GMSPlacesClient.provideAPIKey("AIzaSyB9RhLAU9DdBo94k3JAwecdkQUWxRFKnU8")
        
        
        UIApplication.shared.statusBarStyle = .lightContent

        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let alreadyLogin =  UserDefaults.standard.object(forKey:"isAlreadyLogin") as? String ?? ""
        print(alreadyLogin)
        application.applicationIconBadgeNumber = 0
        if alreadyLogin == "True"{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbar = mainStoryboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            self.window!.rootViewController = tabbar
            self.window!.makeKeyAndVisible()
        }
        
        getCurrentLocation()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        {
            return true
            
        }
        
        return true
        
    }
    
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
        print(self.getlatitude)
        print(self.getlongitude)
        self.locationManager.distanceFilter = 15.0;
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            
            
        }
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

