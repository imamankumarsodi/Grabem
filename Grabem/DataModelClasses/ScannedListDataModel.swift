//
//  ScannedListDataModel.swift
//  Grabem
//
//  Created by Callsoft on 17/01/19.
//  Copyright © 2019 callsoft. All rights reserved.
//

import Foundation
class ScannedListDataModel{
    var discount = String()
    var image1 = String()
    var name = String()
    var created_at = String()
    init(discount:String,image1:String,name:String,created_at:String){
        self.discount = discount
        self.image1 = image1
        self.name = name
        self.created_at = created_at
    }
}
