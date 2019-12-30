//
//  HomeNewsViewController.swift
//  Training
//
//  Created by ManhLD on 12/10/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import Alamofire


class HomeNewsViewController: UIViewController {
    

    @IBOutlet weak var titleHeader: UILabel!
    
    @IBOutlet weak var leadingIncaditor: NSLayoutConstraint!
    
    @IBOutlet weak var imgHeader: UIImageView!
    
    @IBOutlet weak var incaditor: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        let vc1 = NewsViewController()
        addChild(vc1)
        self.leftView.addSubview(vc1.view)
        vc1.view.frame = leftView.bounds
        vc1.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc1.didMove(toParent: self)
        let vc2 = PopularsViewController()
        addChild(vc2)
        self.rightView.addSubview(vc2.view)
        vc2.view.frame = rightView.bounds
        vc2.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc2.didMove(toParent: self)
        scrollView.delegate = self
        titleHeader.text = "Home"
        let localizedContent = NSLocalizedString("Thanks you for download this app", comment: "")
    }
    
    
    @IBAction func btnNews(_ sender: Any) {
         scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    
    @IBAction func btnEvents(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width , y: scrollView.contentOffset.y), animated: true)
    }
}

extension HomeNewsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        leadingIncaditor.constant = scrollView.contentOffset.x / 2
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






