//
//  Common.swift
//  Training
//
//  Created by ManhLD on 12/13/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import UIKit

func handleLoading(isLoading : Bool, loading : UIActivityIndicatorView) {
    if isLoading == true {
        loading.isHidden = false
        loading.startAnimating()
    } else {
        loading.stopAnimating()
        loading.isHidden = true
    }
}

func setUpButton(button : UIButton) {
      button.layer.borderWidth = 0.5
      button.layer.cornerRadius = 5
  }

func setUpCardView(containerView : UIView) {
    containerView.layer.masksToBounds = false
    containerView.layer.cornerRadius = 3.0
    containerView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowRadius = 1.0
    containerView.layer.borderWidth = 1.0
}

func isValidEmail(stringEmail: String) -> Bool {
         let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
         let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         let result = emailTest.evaluate(with: stringEmail)
         return result
}



func isValidPassword(stringPassword: String) -> Bool {
         let passwordRegEx = "(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}"
         let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
         let result = passwordTest.evaluate(with: stringPassword)
         return result
}



