//
//  ResetPassViewController.swift
//  Training
//
//  Created by ManhLD on 12/13/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class ResetPassViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnResetPassword: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "Reset password"
        setUpButton(button: btnResetPassword)
    }


    @IBAction func resetPassword(_ sender: Any) {
        handleLoginView()
    }
    

    func handleLoginView() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
       
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
        containerView.endEditing(true)
    }
}
