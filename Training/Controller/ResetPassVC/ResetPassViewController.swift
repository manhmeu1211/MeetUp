//
//  ResetPassViewController.swift
//  Training
//
//  Created by ManhLD on 12/13/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class ResetPassViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnResetPassword: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var emailView: UIView!
    var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnResetPassword.roundedButton()
        emailView.setUpCardView()
        setUpKeyBoardObservers()
    }
    
    // MARK: - Function setup keyboard
    
    func setUpKeyBoardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyBoardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func handleKeyBoardShow(notification: Notification) {
        if view.frame.origin.y == 0 {
             view.frame.origin.y -= 100
        }
    }
    
    @objc func handleKeyBoardHide(notification : Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    // MARK: - Function reset password
    
    func handleLoginView() {
         isLoginVC = true
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
     }
    
    func resetPassword() {
        let email = txtEmail.text
        if ValidatedString.getInstance.isValidEmail(stringEmail: email!) == false || email!.isEmpty  {
            ToastView.shared.short(self.view, txt_msg: "Email is not correct")
            txtEmail.text = ""
        } else {
            let params = ["email" : email!]
            getDataService.getInstance.resetPassword(params: params) { (json, errCode) in
                if errCode == 1 {
                    self.alert.createAlert(target: self, title: "System error", message: "Email does not exits in system", titleBtn: "OK")
                } else if errCode == 2 {
                    self.alert.createAlert(target: self, title: "Reset password success", message: "Check your email to confirm", titleBtn: "OK")
                } else {
                    ToastView.shared.short(self.view, txt_msg: "Check your network connection")
                }
            }
        }
    }
    
    // MARK: - Actions


    @IBAction func resetPassword(_ sender: Any) {
        resetPassword()
    }
    

    @IBAction func backToLogin(_ sender: Any) {
       handleLoginView()
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
        containerView.endEditing(true)
    }

}

// MARK: - Extension textfied

extension ResetPassViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetPassword()
        return true
    }
}
