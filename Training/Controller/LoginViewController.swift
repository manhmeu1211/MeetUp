//
//  LoginViewController.swift
//  Training
//
//  Created by ManhLD on 12/13/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var uiBtnLogin: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        handleLoading(isLoading: false, loading: loading)
        setUpButton(button: uiBtnLogin)
    }

    func handleForgotPass() {
        let resetPassVC = ResetPassViewController()
        navigationController?.pushViewController(resetPassVC, animated: true)
    }
  
    @IBAction func login(_ sender: Any) {
        guard let mail = txtEmail.text, let pass = txtPassword.text else { return }
        let params = [
                       "email": mail,
                       "password": pass
                    ]
        if txtEmail.text!.isEmpty || txtPassword.text!.isEmpty  {
            ToastView.shared.long(self.view, txt_msg: "Please fill your infomation")
            handleLoading(isLoading: false, loading: loading)
        } else if isValidPassword(stringPassword: pass) == false {
            ToastView.shared.short(self.view, txt_msg: "Password must be 6-16 character, Try again!")
            txtPassword.text = ""
            handleLoading(isLoading: false, loading: loading)
        } else if isValidEmail(stringEmail: mail) == false {
            ToastView.shared.short(self.view, txt_msg: "Email is not correct, Try again!")
            txtEmail.text = ""
            handleLoading(isLoading: false, loading: loading)
        } else {
            let queue = DispatchQueue(label: "Login")
            queue.async {
                getDataService.getInstance.login(params: params) { (json, errcode) in
                    if errcode == 1 {
                        //TODO
                        let data = json!
                        print(data)
                    } else {
                        ToastView.shared.long(self.view, txt_msg: "Login Failed, try again!")
                    }
                }
            }
        }
        
        
    }
    
    
    @IBAction func forgotPass(_ sender: Any) {
        handleForgotPass()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
        containerView.endEditing(true)
    }
    
}
