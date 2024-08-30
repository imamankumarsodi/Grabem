//
//  TabbarVC.swift
//  VirtualGift
//
//  Created by Callsoft on 09/02/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {
    
    @IBOutlet var tabbar: UITabBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   
    override func viewWillLayoutSubviews()
    {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var kBarHeight:CGFloat
        if screenHeight == 812 || screenHeight == 896 {
            kBarHeight = 94
        }else{
            kBarHeight = 64
            
        }
        var tabFrame: CGRect = tabBar.frame
        tabFrame.size.height = kBarHeight
        tabFrame.origin.y = view.frame.size.height - kBarHeight
        tabBar.frame = tabFrame
    }
    

}
