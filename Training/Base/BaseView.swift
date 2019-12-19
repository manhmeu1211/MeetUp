//
//  Common.swift
//  Training
//
//  Created by ManhLD on 12/13/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let token = UserDefaults.standard.string(forKey: "userToken")

var isSearchVC = false
var isLoginVC = false

extension UIActivityIndicatorView {
    
    func handleLoading(isLoading : Bool) {
        if isLoading == true {
            isHidden = false
            startAnimating()
        } else {
            stopAnimating()
            isHidden = true
        }
    }
}

func alertView(titleAlert : String, titleBTN : String, message : String) -> UIAlertController {
        let alertLoginFailed : UIAlertController = UIAlertController(title: titleAlert, message: message, preferredStyle: UIAlertController.Style.alert)
        let btnOK: UIAlertAction = UIAlertAction(title: titleBTN, style: .default, handler: nil)
        alertLoginFailed.addAction(btnOK)
        return alertLoginFailed
    }


extension UIButton {
    
    func setUpButton() {
          layer.borderWidth = 0.5
          layer.cornerRadius = 5
      }
    
    func roundedButton() {
        let maskPath1 = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension UIImageView {
    
    public func roundCorners() {
        let maskPath1 = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
}

extension UIView {
    
    func roundCornersView(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setUpCardView() {
        layer.masksToBounds = false
        layer.cornerRadius = 3.0
        layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1.0
        layer.borderWidth = 1.0
    }
}


