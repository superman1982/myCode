//
//  DetailVC.swift
//  SwiftForTable
//
//  Created by lin on 14-7-3.
//
//

import Foundation
import UIKit

class DetailVC:UIViewController{
    
    var webView:UIWebView = UIWebView();
    var detailURL = "http://qingbin.sinaapp.com/api/html/108035.html"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = self.view.frame
        
        var request = NSURLRequest(URL:NSURL.URLWithString(detailURL))
        webView.loadRequest(request)
        
        self.view.addSubview(webView)
    }
}