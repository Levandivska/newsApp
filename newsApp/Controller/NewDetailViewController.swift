//
//  NewDetailViewController.swift
//  newsApp
//
//  Created by оля on 05.12.2020.
//

import UIKit
import WebKit

class NewDetailViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url: URL? = nil
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url{
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}
