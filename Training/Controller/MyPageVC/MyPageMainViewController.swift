//
//  MyPageMainViewController.swift
//  Training
//
//  Created by ManhLD on 12/17/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class MyPageMainViewController: UIViewController {

    @IBOutlet weak var btnLoginUI: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLoginUI.roundedButton()
        if UserDefaults.standard.string(forKey: "userToken") != nil {
            handleMypage()
        } else {
             print("Not logged in")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func handleMypage() {
        let myPage = MyPageViewController()
        navigationController?.pushViewController(myPage, animated: true)
    }
    
    func handleMainSignUp() {
        let mainSUp = SignUpMainViewController()
        navigationController?.pushViewController(mainSUp, animated: true)
    }
    
    @IBAction func signUpHandle(_ sender: Any) {
       handleMainSignUp()
    }

    @IBAction func loginHandle(_ sender: Any) {
        handleMainSignUp()
    }
}
