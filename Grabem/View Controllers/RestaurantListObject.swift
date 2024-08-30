//
//  RestaurantListObject.swift
//  Grabem
//
//  Created by callsoft on 23/05/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit

class RestaurantListObject: NSObject {
    
    var id: String?
    var name: String?
    var type: String?
    var cuisine: String?
    var city: String?
    var state: String?
    var country: String?
    var pin_code: String?
    var discount: String?
    var phone: String?
    var email : String?
    var image1: String?
    var image2: String?
    var description1: String?
    var description2: String?
    var sitting: String?
    var delivery: String?
    var menu: String?
    var lat: String?
    var long: String?
    var mile: String?

    init(id:String, name: String, type: String, cuisine: String,city: String,state: String,country: String,pin_code: String,discount: String,phone: String,email: String,image1:String,image2:String,description1:String,description2:String,sitting:String,delivery:String,menu:String, lat:String, long:String,mile:String) {
        self.name = name
        self.type = type
        self.cuisine = cuisine
        self.city = city
        self.state = state
        self.country = country
        self.pin_code = pin_code
        self.discount = discount
        self.phone = phone
        self.image1 = image1
        self.image2 = image2
        self.description1 = description1
        self.description2 = description2
        self.sitting = sitting
        self.delivery = delivery
        self.menu = menu
        self.lat = lat
        self.long = long
        self.id  = id
        self.email = email
        self.mile = mile
    }

    // MARK: - NSCoding
    required init(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObject(forKey: "name") as! String
        type = aDecoder.decodeObject(forKey: "type") as! String
        cuisine = aDecoder.decodeObject(forKey: "cuisine") as! String
        city = aDecoder.decodeObject(forKey: "city") as! String
        state = aDecoder.decodeObject(forKey: "state") as! String
        country = aDecoder.decodeObject(forKey: "country") as! String
        pin_code = aDecoder.decodeObject(forKey: "pin_code") as! String
        discount = aDecoder.decodeObject(forKey: "discount") as! String
        phone = aDecoder.decodeObject(forKey: "phone") as! String
        image1 = aDecoder.decodeObject(forKey: "image1") as! String
        image2 = aDecoder.decodeObject(forKey: "image2") as! String
        description1 = aDecoder.decodeObject(forKey: "description1") as! String
        description2 = aDecoder.decodeObject(forKey: "description2") as! String
        sitting = aDecoder.decodeObject(forKey: "sitting") as! String
        delivery = aDecoder.decodeObject(forKey: "delivery") as! String
        menu = aDecoder.decodeObject(forKey: "menu") as! String
        lat = aDecoder.decodeObject(forKey: "lat") as! String
        long = aDecoder.decodeObject(forKey: "long") as! String
        id = aDecoder.decodeObject(forKey: "id") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        mile = aDecoder.decodeObject(forKey: "mile") as! String
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: "name")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(cuisine, forKey: "cuisine")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(pin_code, forKey: "pin_code")
        aCoder.encode(discount, forKey: "discount")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(image1, forKey: "image1")
        aCoder.encode(image2, forKey: "image2")
        aCoder.encode(description1, forKey: "description1")
        aCoder.encode(description2, forKey: "description2")
        aCoder.encode(sitting, forKey: "sitting")
        aCoder.encode(delivery, forKey: "delivery")
        aCoder.encode(menu, forKey: "menu")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(long, forKey: "long")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(mile, forKey: "mile")

    }
    
}

