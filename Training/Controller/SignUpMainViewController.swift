//
//  SignUpMainViewController.swift
//  Training
//
//  Created by ManhLD on 12/17/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit

class SignUpMainViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var incaditor: UIView!
    
    @IBOutlet weak var incaditorLeading: NSLayoutConstraint!
    
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
        let vc1 = LoginViewController()
        addChild(vc1)
        self.leftView.addSubview(vc1.view)
        vc1.view.frame = leftView.bounds
        vc1.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc1.didMove(toParent: self)
        let vc2 = SignUpViewController()
        addChild(vc2)
        self.rightView.addSubview(vc2.view)
        vc2.view.frame = rightView.bounds
        vc2.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc2.didMove(toParent: self)
        scrollView.delegate = self
       
    }
    
 
        
      
 
    @IBAction func loginBtn(_ sender: Any) {
         scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    
    @IBAction func signUpBtn(_ sender: Any) {
          scrollView.setContentOffset(CGPoint(x: scrollView.frame.width , y: scrollView.contentOffset.y), animated: true)
    }
    
}

extension SignUpMainViewController: UIScrollViewDelegate {
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
