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
    
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var emailView: UIView!
    
    
    @IBOutlet weak var passwordView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        nameView.setUpCardView()
        emailView.setUpCardView()
        passwordView.setUpCardView()
        uiBtn.roundedButton()
        loading.handleLoading(isLoading: false)
    }
    
    
    func handleLogged() {
        let token = UserDefaults.standard.string(forKey: "userToken")
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
         loading.handleLoading(isLoading: true)
        guard let mail = email.text , let name = fullName.text, let pass = password.text else { return }
        if isValidEmail(stringEmail: mail) == false {
            ToastView.shared.short(self.view, txt_msg: "Email is not correct, Try again!")
            email.text = ""
            loading.handleLoading(isLoading: false)
        } else if isValidPassword(stringPassword: pass) == false {
                        ToastView.shared.short(self.view, txt_msg: "Password must be 6-16 character, Try again!")
                        password.text = ""
                        loading.handleLoading(isLoading: false)
        } else if email.text!.isEmpty || password.text!.isEmpty || fullName.text!.isEmpty {
                        ToastView.shared.long(self.view, txt_msg: "Please fill your infomation")
                        loading.handleLoading(isLoading: false)

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
                        self.loading.handleLoading(isLoading: false)
                    } else {
                        self.loading.handleLoading(isLoading: false)
                        ToastView.shared.short(self.view, txt_msg: "Register Failed, Check your network")
                    }
                }
            }
        }
    }
 
    @IBAction func btnIgnore(_ sender: Any) {
        isSearchVC = false
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
