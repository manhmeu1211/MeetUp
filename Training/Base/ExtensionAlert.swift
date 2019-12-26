//
//  ExtensionAlert.swift
//  Training
//
//  Created by ManhLD on 12/25/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import Foundation
import UIKit

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
            dismiss(animated: true, completion: nil)
        }
    }
}

