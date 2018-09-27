
//
//  Created by 绝非 on 2018/2/1.
//  Copyright © 2018年 绝非. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

func XBLog<T>(_ message : T,methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
    print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

extension JFWebViewController:WKNavigationDelegate{
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        view.showActivity()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        view.hideActivity()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        view.showToast("加载失败")
    }
    
    /*
     * 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
     * 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        progressView.alpha = 1
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    }
    
    
    @available(iOS 9.0, *)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        XBLog("进程被终止")
        XBLog(webView.url)
        webView.reload()
    }
    
}


extension JFWebViewController:WKUIDelegate{
    
    /*
     * 网页中有target="_blank" 在新窗口打开链接 需要实现此方法
     */
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame == false {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(action)
        
        if isViewLoaded && (view.window != nil) {
            present(alert, animated: true, completion: nil)
        }else{
            completionHandler()
        }
 
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "确定", style: .default) { (action) in
            completionHandler(true)
        }
        let action2 = UIAlertAction(title: "取消", style: .cancel) { (action) in
            completionHandler(false)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
}


extension JFWebViewController:WKScriptMessageHandler{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        XBLog(message)
        
        if message.name == JSObjectName {
            if let body = checkString(message.body){
                let json = JSON(parseJSON: body)
                if var methodName = json["method"].stringify{
                    var params : String? = nil
                    if let p = json["params"].stringify{
                        params = p
                        methodName += ":"
                    }
                    let selector =  Selector(methodName)
                    if self.responds(to: selector){
                        if let callback = json["callback"].stringify{
                            self.callbackName = callback
                        }
                        //当前线程是否要被阻塞
                        self.performSelector(onMainThread: selector, with: params, waitUntilDone: true)
                    }else{
                        XBLog("webview not find method" + methodName)
                    }
                }
            }
        }
    }
    
    func checkString(_ string:Any?) -> String? {
        if let s = string as? String, !s.isEmpty{
            return s
        }
        return nil
    }
    
}


extension JFWebViewController{
    
    /*
     * webview kvo
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let ob = object,ob as? JFWebView == webView{
            if let key = keyPath{
                if key == "title"{
                    navigationItem.title =  change![.newKey] as? String
                }else if key == "estimatedProgress"{
                    progressView.setProgress(Float(truncating: change![.newKey] as! NSNumber) , animated: true)
                }
                
                if !webView!.isLoading {
                    view.hideActivity()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.progressView.alpha = 0
                        self.progressView.setProgress(1, animated: true)
                    }){ (c) in
                        self.progressView.setProgress(0, animated: false)
                    }
                }else{
                    self.progressView.alpha = 1
                }
            }
        }
    }
    
}


/*
 * 空字符串也返回nil
 */
extension JSON{
    
    public var stringify: String? {
        get {
            switch self.type {
            case .string:
                if let s =  self.object as? String, !s.isEmpty{
                    return s
                }
                return nil
            default:
                return nil
            }
        }
        set {}
    }
    
}


