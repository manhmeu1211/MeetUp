//
//  WebViewController.swift
//  Training
//
//  Created by ManhLD on 12/20/19.
//  Copyright © 2019 ManhLD. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class WebViewController: UIViewController {
    
    var urlToOpen : String?
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(urlToOpen!)
        if let url = URL(string: urlToOpen!) {
          let request = URLRequest(url: url)
          webView.load(request)
      }
    }
    
       override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.navigationDelegate = self
            self.view = webView
     }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
}
