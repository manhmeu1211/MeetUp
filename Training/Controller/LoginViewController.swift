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
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var uiBtnLogin: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpItemBar()
        setupView()
    }
    
    
    func setupView() {
        loading.handleLoading(isLoading: false)
        uiBtnLogin.roundedButton()
        emailView.setUpCardView()
        passwordView.setUpCardView()
    }
    
    func setUpItemBar() {
        self.title = "Login"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "SignUp", style: UIBarButtonItem.Style.plain, target: self, action: #selector(toRegister))
    }
    
    @objc func toRegister() {
        let regisVC = SignUpViewController()
        navigationController?.pushViewController(regisVC, animated: true)
    }

    func handleForgotPass() {
        let resetPassVC = ResetPassViewController()
        navigationController?.pushViewController(resetPassVC, animated: true)
    }
    
    func handleMyPage() {
        let myPageVC = MyPageViewController()
        navigationController?.pushViewController(myPageVC, animated: true)
    }
    
    func isLoggedIn() -> Bool {
        return false
    }
    
    
    func saveLogginRes(token : String) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(token, forKey: "userToken")
        UserDefaults.standard.synchronize()
    }
    
    func saveToken(token : String) {
          UserDefaults.standard.set(token, forKey: "userToken")
      }
    
    func alerView(titleAlert : String, message : String, titleBtn : String) {
        let alertLoginFailed : UIAlertController = UIAlertController(title: titleAlert, message: message, preferredStyle: UIAlertController.Style.alert)
                   let btnOK: UIAlertAction = UIAlertAction(title: titleBtn, style: .default, handler: nil )
                   alertLoginFailed.addAction(btnOK)
        present(alertLoginFailed, animated: true, completion: nil)
    }
  
    
    func login() {
        loading.handleLoading(isLoading: true)
            guard let mail = txtEmail.text, let pass = txtPassword.text else { return }
            let params = [  "email": mail,
                            "password": pass    ]
            if txtEmail.text!.isEmpty || txtPassword.text!.isEmpty  {
                ToastView.shared.long(self.view, txt_msg: "Please fill your infomation")
                loading.handleLoading(isLoading: false)
            } else if isValidPassword(stringPassword: pass) == false {
                ToastView.shared.short(self.view, txt_msg: "Password must be 6-16 character, Try again!")
                txtPassword.text = ""
                loading.handleLoading(isLoading: false)
            } else if isValidEmail(stringEmail: mail) == false {
                ToastView.shared.short(self.view, txt_msg: "Email is not correct, Try again!")
                txtEmail.text = ""
                loading.handleLoading(isLoading: false)
            } else {
                let queue = DispatchQueue(label: "Login")
                queue.async {
                    getDataService.getInstance.login(params: params) { (json, errcode) in
                        if errcode == 1 {
                            self.alerView(titleAlert: "Login failed", message: "Wrong pass or username", titleBtn: "OK")
                            self.loading.handleLoading(isLoading: false)
                            self.txtPassword.text = ""
                        } else if errcode == 2 {
                            let data = json!
                            let token = data["token"].stringValue
                            self.saveToken(token: token)
                            self.handleMyPage()
                        } else {
                            self.alerView(titleAlert: "Login failed", message: "Check your interent connection", titleBtn: "OK")
                            self.loading.handleLoading(isLoading: false)
                        }
                    }
                }
            }
        }
    
    @IBAction func login(_ sender: Any) {
       login()
    }
    
  
    @IBAction func ignore(_ sender: Any) {
        isSearchVC = false
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
   
    }
    
    
    @IBAction func forgotPass(_ sender: Any) {
        handleForgotPass()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
        containerView.endEditing(true)
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        login()
        return true
    }
}


