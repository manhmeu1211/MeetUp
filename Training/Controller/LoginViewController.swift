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
        
    }
    
    
    @IBAction func forgotPass(_ sender: Any) {
        handleForgotPass()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
        containerView.endEditing(true)
    }
    
}
