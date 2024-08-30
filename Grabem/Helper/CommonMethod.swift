//
//  Common.swift

//  Created by Saurabh on 11/24/15.
//  Copyright © 2017 Mobulous. All rights reserved.
//
import CoreLocation
import CoreData
import UIKit


class CommonMethod: NSObject {

    var isCheck : Bool = false

    
    class func appDelegate()->AppDelegate{

        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    
    //MARK:Alert
    
    class func makeAlert(alertMsg:String){
        
    let alert =   UIAlertView(title: "", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
        
      alert.show()
       
    }

    class func getCurrentCity(lat:CLLocationDegrees,long:CLLocationDegrees) {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude:long )
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            guard let code = placemarks?[0].locality else {
                return
            }
            
            print(code)
            // Print eaccodeh key-value pair in a new row
            addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
            }
            
            // Access each element manually
            if let locationName = addressDict["Name"] as? String {
                print(locationName)
            }
            if let street = addressDict["Thoroughfare"] as? String {
                print(street)
            }
            if let city = addressDict["City"] as? String {
//                textFldCity.text = city
            }
            if let zip = addressDict["ZIP"] as? String {
                print(zip)
            }
            if let country = addressDict["Country"] as? String {
                print(country)
//                textFldCountry.text = country
                
            }
            
        })
    }
    //MARK:validation
    
    class func validateEmptyString(name:String, withIdentifier:String)-> Bool{
        
        if name.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            let str = String(format: "Please enter %@", withIdentifier)
            self.makeAlert(alertMsg: str)
             return false
        }
        
        if (name.isEmpty || name.length == 0) {
            
            let str = String(format: "Please enter %@", withIdentifier)
            self.makeAlert(alertMsg: str)
            return false
        }
        
        if withIdentifier == "password"{
        
            if (name.length < 6 || name.length > 15 ) {
                let str = String(format: "Please enter password between 6 to 15 character", withIdentifier)
                self.makeAlert(alertMsg: str)
                return false
            }
        }
        
        if withIdentifier == "first name" || withIdentifier == "last name"{
            
            let numberRegex:String = "[A-Za-z]+$"
            let numberTest:NSPredicate = NSPredicate(format:"SELF MATCHES %@",numberRegex)
            if !numberTest .evaluate(with: name){
                let str = String(format: "Please enter correct %@ (only string)", withIdentifier)
                self.makeAlert(alertMsg: str)
                return false
           }
        
        }
        return true
    }
    
    class func validateEmptyOption(name:String, withIdentifier:String)-> Bool {
        if (name.isEmpty || name.length == 0) {
            
            let str = String(format: "Please select %@", withIdentifier)
            self.makeAlert(alertMsg: str)
            return false
        }
        
      return true
    }
    
    class func validateEmailWithString(email:String, withIdentifier:String)->Bool {
        
        if (email.isEmpty || email.length == 0)
        {
            let str = String(format: "Please enter %@", withIdentifier)
            self.makeAlert(alertMsg: str)
            return false
            
        }
        else
        {
            let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest:NSPredicate = NSPredicate(format:"SELF MATCHES %@",emailRegex)
            if !emailTest .evaluate(with: email){
                let str = String(format: "Please enter valid %@", withIdentifier)
                self.makeAlert(alertMsg: str)
                return false
            }
        }
        return true
    }
    
//    class func validate(textView: UITextView, withIdentifier: String) -> Bool {
//        guard let text = textView.text,
//            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
//                // this will be reached if the text is nil (unlikely)
//                // or if the text only contains white spaces
//                // or no text at all
//                return false
//        }
//        
//        return true
//    }
    
    
    class func validatePhoneNumberWithString(number:String, withIdentifier:String)->Bool {
        
        if (number.isEmpty || number.length == 0)
        {
            let str = String(format: "Please enter %@", withIdentifier)
            self.makeAlert(alertMsg: str)
            return false
        }
        if number.length < 10
        {
            let str = String(format: "Please enter valid %@", withIdentifier)
            self.makeAlert(alertMsg: str)
            return false
        }
    
        let numberRegex:String = "[0-9+]+$"
 
        let numberTest:NSPredicate = NSPredicate(format:"SELF MATCHES %@",numberRegex)
        if !numberTest .evaluate(with: number){
            let str = String(format: "Please enter valid %@", withIdentifier)
            self.makeAlert(alertMsg: str)
            return false
        }
        
        return true
    }
    
    class func getStringFromDictioniory(data:NSDictionary,key:String) -> String {
        
        if let info = data[key] as? String{
            
            return info
        }
        return ""
    }
    
    class func generateDictionary(name:String,email:String, mobileNo:String, hobbies:String,city:String, country:String, password:String,CountryCode : String,lat : String,long : String) -> Dictionary<String, String> {
       var dict = Dictionary<String, String>()
        
            dict["name"] = name
            dict["email"] = email
            dict["mobileNo"] = mobileNo
            dict["hobbies"] = hobbies
            dict["country"] = country
            dict["country_code"] = CountryCode
            dict["city"] = city
            dict["password"] = password
            dict["lat"] = lat
            dict["long"] = long
            return dict
    }
    
//    class func getDictionaryFromXMLFile(_ filename: String, fileExtension `extension`: String) -> [AnyHashable: Any] {
//
//        let configFileURL: URL? = Bundle.main.url(forResource: filename, withExtension: `extension`)
//        let xmlString = try? String(contentsOf: configFileURL!, encoding: String.Encoding.utf8)
//        let xmlDoc: [AnyHashable: Any]? = try? XMLReader.dictionary(forXMLString: xmlString)
//        return xmlDoc!
//
//    }
    
    class func convertdurationToString(durationVlaue:String) -> String{
    
    
        print(durationVlaue)
        let chars = CharacterSet(charactersIn: "Hours,Minute")
        let hoursAndMinutes = durationVlaue.components(separatedBy: chars)
        let durationArr:NSMutableArray = NSMutableArray()
        for element in hoursAndMinutes {
            if element == ""{
                
            }else{
                durationArr.add(element)
            }
        }
        var hourValue = Int()
        var minValue = Int()
        if durationArr.count == 1{
            
            hourValue = 0
            let mintValue = durationArr.object(at: 0) as! String
            minValue = Int(mintValue.trimmingCharacters(in: .whitespaces))!
            
        }else{
            let hours = durationArr.object(at: 0) as! String
            let mintValue = durationArr.object(at: 1) as! String
            hourValue = Int(hours.trimmingCharacters(in: .whitespaces))!
            minValue = Int(mintValue.trimmingCharacters(in: .whitespaces))!
        }
        
        print(hourValue)
        print(minValue)
        let decimalMinValue = Float(minValue) / Float(60)
        
        print(Float(hourValue) + decimalMinValue)
        let duration = (Float(hourValue) + decimalMinValue)
        let stringDuration = String(format:"%02i",hourValue) + ":\(minValue)"
        print(duration)
        print(stringDuration)
       return stringDuration
    
    }

    class func changeDateFormate(date:String) -> String{
        
        if date == ""{
            
         return ""
            
        }else{
            
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)

        let calendar = Calendar.current
        let month = calendar.component(.month, from: date!)
        let monthName = DateFormatter().monthSymbols[month - 1]
        let day = calendar.component(.day, from: date!)
    
        let index = monthName.index(monthName.startIndex, offsetBy: 3)
        let subString =  monthName.substring(to: index)
        
        let splitYear = String(day) + " " + subString
    
         return splitYear
        }
    }
    
       class func dateConversion(date: String) -> String {
    
        let dateString = String(describing: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dates = dateFormatter.date(from: dateString)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter1.string(from: dates!)
        print(convertedDate)
        return String(convertedDate)
    
    }
    
    class func convertDateFormate(stringDate:String) -> String{
    
        let dateString = stringDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dates = dateFormatter.date(from: dateString)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd-MMM-yyyy"
        let dateString1 = dateFormatter1.string(from: dates!)
        print(dateString1)
        return dateString1
    }
    
    class func dateFormateForSever(stringDate:String) -> String{
        
        let dateString = stringDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dates = dateFormatter.date(from: dateString)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let dateString1 = dateFormatter1.string(from: dates!)
        print(dateString1)
        return dateString1
    }
    
    class func getCurrentCity(lat:CLLocationDegrees,long:CLLocationDegrees,textFldCity:UITextField,textFldCountry:UITextField){

    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: lat, longitude:long )
    
       geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
         guard let addressDict = placemarks?[0].addressDictionary else {
            return
      }
    
    // Print each key-value pair in a new row
       addressDict.forEach { print($0) }
    
    // Print fully formatted address
       if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
       print(formattedAddress.joined(separator: ", "))
       }
    
    // Access each element manually
       if let locationName = addressDict["Name"] as? String {
       print(locationName)
       }
       if let street = addressDict["Thoroughfare"] as? String {
    print(street)
      }
       if let city = addressDict["City"] as? String {
         textFldCity.text = city
       }
      if let zip = addressDict["ZIP"] as? String {
       print(zip)
       }
       if let country = addressDict["Country"] as? String {
       print(country)
        textFldCountry.text = country
       }

       })
    
   }

    
    class func fromatedAddress(line1:String, line2:String ,city:String,country:String) -> String{
        
        var address = ""
        
        if line1 != ""{
        
            address = line1 + ", "
        }
        if line2 != ""{
            
            address = address + line2 + ", "
        }
        if city != ""{
            
            address = address + city + "\n"
        }
        if country != ""{
            
            address = address + country
        }
        
        return address
    }
    
    class func makeAlertForAlreadyLogin(alertMsg:String) {
       
        let alertController = UIAlertController(title: "", message: alertMsg, preferredStyle:UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            
            if alertMsg == AppConstants.kAlredyLoginMsgDisplay{
                
                UserDefaults.standard.set("False", forKey: "isAlreadyLogin")
                UserDefaults.standard.set("", forKey: "token")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showLogin"), object: nil, userInfo : ["index" : 1 ])
                
            }else{
                
                
            }
            
        })
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    class func isLocationServiceEnabled() -> String {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                
            case .restricted, .denied:
                return "false"
            case .notDetermined:
                return "Not Determine"
            case .authorizedAlways, .authorizedWhenInUse:
                return "true"
            }
        } else {
            print("Location services are not enabled")
            return "Not Determine"
        }
    }

    
    class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}


