//
//  TabbarViewController.swift
//  Training
//
//  Created by ManhLD on 12/18/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit


var isLoginVC = false

class TabbarViewController: UITabBarController {
    // MARK: - Check index tabbar view
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLoginVC == true {
            self.selectedIndex = 3
        } else {
            self.selectedIndex = 0
        }
    }
}
