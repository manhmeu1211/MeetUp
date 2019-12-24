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

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension UIAlertController {
    func createAlert(target: UIViewController, title : String? = nil, message : String? = nil, titleBtn: String? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let btnOK: UIAlertAction = UIAlertAction(title: titleBtn, style: .default, handler: nil)
        alertVC.addAction(btnOK)
        target.present(alertVC, animated: true, completion: nil)
    }
    
    func createAlertWithHandle(target: UIViewController, title : String? = nil, message : String? = nil, titleBtn: String? = nil, handler: @escaping () -> Void) {
           let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           let btnOK: UIAlertAction = UIAlertAction(title: titleBtn, style: .default, handler: {(alert: UIAlertAction!) in handler()})
           alertVC.addAction(btnOK)
           target.present(alertVC, animated: true, completion: nil)
    }
    
    func createAlertLoading(target: UIViewController, isShowLoading : Bool) {
        if isShowLoading == true {
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            target.present(alert, animated: true, completion: nil)
        } else {
            target.dismiss(animated: true, completion: nil)
        }
    }
}




