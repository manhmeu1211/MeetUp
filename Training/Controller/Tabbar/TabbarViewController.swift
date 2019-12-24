//
//  TabbarViewController.swift
//  Training
//
//  Created by ManhLD on 12/18/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isSearchVC == true {
            self.selectedIndex = 2
        } else if isLoginVC == true {
            self.selectedIndex = 3
        } else {
            self.selectedIndex = 0
        }
    }
}
