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
    
    
    
    @IBOutlet weak var btnView: UIView!
    
    
    @IBOutlet weak var incaditorLeading: NSLayoutConstraint!
    
    
    @IBOutlet weak var going: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var leftView: UIView!
    
    
    @IBOutlet weak var rightView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
      func setUpView() {
          tabBarController?.tabBar.isHidden = true
          scrollView.showsHorizontalScrollIndicator = false
          scrollView.showsVerticalScrollIndicator = false
          let vc1 = MyPageGoingViewController()
          addChild(vc1)
          self.leftView.addSubview(vc1.view)
          vc1.view.frame = leftView.bounds
          vc1.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          vc1.didMove(toParent: self)
          let vc2 = MyPageWentViewController()
          addChild(vc2)
          self.rightView.addSubview(vc2.view)
          vc2.view.frame = rightView.bounds
          vc2.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          vc2.didMove(toParent: self)
          scrollView.delegate = self
      }
    
    func logOut() {
        deleteToken()
        navigationController?.popViewController(animated: true)
    }
       
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: "userToken")
    }

    @IBAction func goingBtn(_ sender: Any) {
         scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    @IBAction func wentBtn(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width , y: scrollView.contentOffset.y), animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        logOut()
    }
    
    @IBAction func backHome(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension MyPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        incaditorLeading.constant = scrollView.contentOffset.x / 2
        if scrollView.contentOffset.x >= scrollView.bounds.width / 2 {
            if scrollView.contentOffset.x == scrollView.bounds.width {
                scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width , y: scrollView.contentOffset.y), animated: false)
            }
        } else {
            if scrollView.contentOffset.x == 0 {
                scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
                scrollView.endEditing(true)
            }
        }
    }
}


