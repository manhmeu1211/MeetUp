//
//  HomeNewsViewController.swift
//  Training
//
//  Created by ManhLD on 12/10/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import Alamofire
import CarbonKit

class HomeNewsViewController: UIViewController, CarbonTabSwipeNavigationDelegate {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        let tabSwipe = CarbonTabSwipeNavigation(items: ["NEWS", "POPULARS"], delegate: self)
        tabSwipe.setTabExtraWidth(40)
        tabSwipe.insert(intoRootViewController: self)
    }
  
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if index == 0 {
            let newsVC = NewsViewController()
                return newsVC
        }
        let popularsVC = PopularsViewController()
        return popularsVC
      }
}





