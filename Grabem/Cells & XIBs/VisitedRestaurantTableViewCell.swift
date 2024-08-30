//
//  VisitedRestaurantTableViewCell.swift
//  Grabem
//
//  Created by Callsoft on 16/01/19.
//  Copyright © 2019 callsoft. All rights reserved.
//

import UIKit

class VisitedRestaurantTableViewCell: UITableViewCell {
    //MARK: - Outlets
    
    @IBOutlet weak var lblLastVisited: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewRestaurent: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func configure(with item:ScannedListDataModel){
        lblName.text = item.name
        lblDiscount.text = "Discount \(item.discount)% Saved"
        lblLastVisited.text = "Date \(item.created_at)"
        
        let url1 = URL(string: item.image1)
        
        if url1 != nil{
            imgViewRestaurent.af_setImage(withURL: url1!, placeholderImage:UIImage(named:"cafeimg_desc"))
        }else{
            
            imgViewRestaurent.af_setImage(withURL: url1!, placeholderImage:UIImage(named:"cafeimg_desc"))
        }
        
        
    }
    
}
