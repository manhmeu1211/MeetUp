//
//  SignUpViewController.swift
//  Training
//
//  Created by ManhLD on 12/17/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var uiBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        uiBtn.roundedButton()
        handleLoading(isLoading: false, loading: loading!)
    }
    
    
    func handleLogged() {
           if token != nil {
               let vc = MyPageViewController()
               navigationController?.pushViewController(vc, animated: false)
           } else {
                      
           }
       }
    
    func handleLoginView() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
       
    

    @IBAction func dismissKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        handleLoading(isLoading: true, loading: loading)
        guard let mail = email.text , let name = fullName.text, let pass = password.text else { return }
        if isValidEmail(stringEmail: mail) == false {
            ToastView.shared.short(self.view, txt_msg: "Email is not correct, Try again!")
            email.text = ""
            handleLoading(isLoading: false, loading: loading)
        } else if isValidPassword(stringPassword: pass) == false {
                        ToastView.shared.short(self.view, txt_msg: "Password must be 6-16 character, Try again!")
                        password.text = ""
                        handleLoading(isLoading: false, loading: loading)
        } else if email.text!.isEmpty || password.text!.isEmpty || fullName.text!.isEmpty {
                        ToastView.shared.long(self.view, txt_msg: "Please fill your infomation")
                        handleLoading(isLoading: false, loading: loading)

        } else {
            let params = [
                "name": name,
                "email": mail,
                "password": pass
                ]
            let queue = DispatchQueue(label: "Register")
            queue.async {
                getDataService.getInstance.register(params: params) { (json, errcode) in
                    if errcode == 1 {
                        ToastView.shared.short(self.view, txt_msg: "Register Success")
                        self.handleLoginView()
                        handleLoading(isLoading: false, loading: self.loading)
                    } else {
                        handleLoading(isLoading: false, loading: self.loading)
                        ToastView.shared.short(self.view, txt_msg: "Register Failed, Check your network")
                    }
                }
            }
        }
    }
 
}
