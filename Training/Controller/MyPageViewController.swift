//
//  MyPageViewController.swift
//  Training
//
//  Created by ManhLD on 12/16/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var uiBtnLogOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiBtnLogOut.layer.cornerRadius = 20
        tabBarController?.tabBar.isHidden = false
    }


    @IBAction func logOut(_ sender: Any) {
        logOut()
    }
    
    func logOut() {
        deleteToken()
       let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        isSearchVC = false
    }
}
