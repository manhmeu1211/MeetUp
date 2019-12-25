//
//  WebViewController.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var urlToOpen : String?
    
    @IBOutlet weak var webViewV2: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestToUrlNews(url: urlToOpen ?? "https://google.com.vn")
    }
    
    private func requestToUrlNews(url: String){
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        webViewV2.load(request)
    }
   

}


