//
//  ViewController.swift
//  swiftDemo
//
//  Created by 绝非 on 2018/9/29.
//  Copyright © 2018年 绝非. All rights reserved.
//

import UIKit

class ViewController: JFWebViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView?.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path:String! = Bundle.main.path(forResource: "index", ofType: "html")
        webView?.load(URLRequest(url: URL(fileURLWithPath: path)))
    }

    
    //实现子类自己的逻辑
    override func save(_ image: String) {
        print("js传递给ios的参数:" + image)
        self.webView?.evaluateJavaScript("\(callbackName ?? "")('这是ios回调给js的返回值');", completionHandler: nil)
    }
    
}

