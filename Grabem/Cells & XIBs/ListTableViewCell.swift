//
//  ListTableViewCell.swift
//  Redbean
//
//  Created by callsoft on 12/04/18.
//  Copyright © 2018 callsoft. All rights reserved.
//

import UIKit
import CoreLocation

class ListTableViewCell: UITableViewCell {
  
    
    @IBOutlet weak var imgRestraunt: UIImageView!
    @IBOutlet weak var imgSeperator: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblFoodType: UILabel!
    @IBOutlet weak var lblRestrauntName: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var btnMail: UIButton!
    @IBOutlet var btnCall: UIButton!
    
    @IBOutlet var btnDistance: UIButton!
    
    @IBOutlet weak var imgMessage: UIImageView!
    
    @IBOutlet weak var imgCall: UIImageView!
    
    
    
    override func awakeFromNib() {
        
        imgRestraunt.layer.cornerRadius = 5
        imgRestraunt.clipsToBounds = true
                
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
