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
    
    @IBOutlet weak var emailView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnResetPassword.roundedButton()
        emailView.setUpCardView()
    }


    @IBAction func resetPassword(_ sender: Any) {
        handleLoginView()
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        isLoginVC = true
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func handleLoginView() {
        let loginVC = SignUpMainViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
       
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
        containerView.endEditing(true)
    }
}
