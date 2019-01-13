//
//  WebViewController.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/15.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func webPageLoad(url: String) {
        guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) else { return }
        let request = URLRequest(url: url )
        
        DispatchQueue.main.async {
            self.webView.load(request)
        }
    }
    
}
