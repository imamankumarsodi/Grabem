//
//  Helper.swift
//  BooksApp
//
//  Created by Mrityunjay Ojha on 16/07/16.
//  Copyright © 2016 mobulous. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Helper
{
    static var isLogin : Bool = false
    static var isSocial : Bool = false
    static var CheckAddLocation : Bool = false

    
    static func paddingTxtField(txtfld: UITextField)
    {
        let paddingtxtfld = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtfld.frame.height))
        txtfld.leftView = paddingtxtfld
        txtfld.leftViewMode = UITextFieldViewMode.always
    }
    
    static func updateLineSpacing(str : String) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: str)
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineSpacing = CGFloat(5)
        
        if let stringLength = str.characters.count as? Int
        {
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: mutableParagraphStyle, range: NSMakeRange(0, stringLength))
        }
        
        return attributedString
    }
    
    static func changeDayFormat(day : String) -> String
    {
        var d = ""
        if day.characters.last == "1"
        {
            d = "\(day)st"
        }
        else if day.characters.last == "2"
        {
            d = "\(day)nd"
        }
        else
        {
            d = "\(day)th"
        }
        return d
    }
    
    static func getMonthName(mon : String) -> String
    {
        var monthName = ""
        
        if mon == "01"
        {
            monthName = "January"
        }
        else if mon == "02"
        {
            monthName = "February"
        }
        else if mon == "03"
        {
            monthName = "March"
        }
        else if mon == "04"
        {
            monthName = "April"
        }
        else if mon == "05"
        {
            monthName = "May"
        }
        else if mon == "06"
        {
            monthName = "June"
        }
        else if mon == "07"
        {
            monthName = "July"
        }
        else if mon == "08"
        {
            monthName = "August"
        }
        else if mon == "09"
        {
            monthName = "September"
        }
        else if mon == "10"
        {
            monthName = "October"
        }
        else if mon == "11"
        {
            monthName = "November"
        }
        else if mon == "12"
        {
            monthName = "December"
        }
        return monthName
    }
    
    static func flipButton(btn : AnyObject, img : UIImage)
    {
        UIView.animate(withDuration: 0.7, delay: 1.0, options: .transitionFlipFromTop, animations:
            {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
                UIView.transition(  with: btn as! UIView , duration: 0.5, options: transitionOptions, animations:
                    {
                        btn.setImage(img, for: .normal)
                    let delay = 0.5 * Double(NSEC_PER_SEC)
                    }, completion: nil)
            }, completion: { finished in
        })
    }
    
    static func animateScrollViewHorizontally(destinationPoint destination: CGPoint, andScrollView scrollView: UIScrollView, andAnimationMargin margin: CGFloat) {
        
        var change: Int = 0;
        let diffx: CGFloat = destination.x - scrollView.contentOffset.x;
        var _: CGFloat = destination.y - scrollView.contentOffset.y;
        
        if(diffx < 0) {
            
            change = 1
        }
        else {
            
            change = 2
            
        }
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3);
        UIView.setAnimationCurve(.easeIn);
        switch (change) {
            
        case 1:
            scrollView.contentOffset = CGPoint(x: destination.x - margin, y: destination.y);
        case 2:
            scrollView.contentOffset = CGPoint(x: destination.x + margin, y: destination.y);
        default:
            return;
        }
        
        UIView.commitAnimations();
        
        let firstDelay: Double  = 0.3;
        let startTime: DispatchTime = DispatchTime.now() + Double(Int64(firstDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: startTime, execute: {
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2);
            UIView.setAnimationCurve(.linear);
            switch (change) {
                
            case 1:
                scrollView.contentOffset = CGPoint(x: destination.x + margin, y: destination.y);
            case 2:
                scrollView.contentOffset = CGPoint(x: destination.x - margin, y: destination.y);
            default:
                return;
            }
            
            UIView.commitAnimations();
            let secondDelay: Double  = 0.2;
            let startTimeSecond: DispatchTime = DispatchTime.now() + Double(Int64(secondDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: startTimeSecond, execute: {
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.1);
                UIView.setAnimationCurve(.easeInOut);
                scrollView.contentOffset = CGPoint(x: destination.x, y: destination.y);
                UIView.commitAnimations();
                
            })
        })
    }
}


