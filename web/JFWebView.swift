
//
//  Created by 绝非 on 2017/12/15.
//  Copyright © 2017年 绝非. All rights reserved.
//

import UIKit
import WebKit

let JSObjectName = "kf"

class WeakScriptMessageDelegate: NSObject,WKScriptMessageHandler{
    
    weak var scriptDelegate : WKScriptMessageHandler?
    
    init(scriptDelegate:WKScriptMessageHandler) {
        super.init()
        self.scriptDelegate = scriptDelegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
    
}


class JFWebView: WKWebView {

    static let processPool = WKProcessPool()
    
    weak var delegate : JFWebViewController?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame:CGRect,delegate:JFWebViewController) {
       
        //MARK:注入UA， ios9 可以 customUA
        let webView = UIWebView(frame: frame)
        let userAgent = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
        let v = "your UA"
        let dictionary = ["UserAgent":newUserAgent]
        UserDefaults.standard.register(defaults: dictionary)
        
        let config = WKWebViewConfiguration()
        config.processPool = JFWebView.processPool
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = true;
        config.preferences.javaScriptCanOpenWindowsAutomatically = false;
        config.allowsInlineMediaPlayback = true;
        config.mediaPlaybackRequiresUserAction = false;
        if #available(iOS 9.0, *) {
            config.allowsAirPlayForMediaPlayback = true
            config.allowsPictureInPictureMediaPlayback = false
        }
        if #available(iOS 10.0, *) {
            config.ignoresViewportScaleLimits = false
        }
        config.userContentController = WKUserContentController()
        config.userContentController.add(WeakScriptMessageDelegate.init(scriptDelegate: delegate as WKScriptMessageHandler), name: JSObjectName)
        //注入cookie
//        let cookieScript = WKUserScript(source: BaseWebView.cookiesForWeb(), injectionTime: .atDocumentStart, forMainFrameOnly: false)
//        config.userContentController.addUserScript(cookieScript)

        if let source = try? String.init(contentsOfFile:Bundle.main.path(forResource: "ios_brige", ofType: "js")!, encoding: .utf8){
            let userScript = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            config.userContentController.addUserScript(userScript)
        }
        
        self.init(frame: frame, configuration: config, delegate: delegate)
    }
    
    init(frame: CGRect, configuration: WKWebViewConfiguration,delegate:AnyObject) {
        super.init(frame: frame, configuration: configuration)
        if ((delegate as? WKNavigationDelegate) != nil) {
            navigationDelegate = delegate as? WKNavigationDelegate
        }
        if ((delegate as? WKUIDelegate) != nil) {
            uiDelegate = delegate as? WKUIDelegate
        }
        allowsBackForwardNavigationGestures = true
        addObserver(delegate as! NSObject, forKeyPath: "estimatedProgress", options: .new, context: nil)
        addObserver(delegate as! NSObject, forKeyPath: "loading", options: .new, context: nil)
        addObserver(delegate as! NSObject, forKeyPath: "title", options: .new, context: nil)
        evaluateJavaScript("navigator.userAgent", completionHandler: nil)
    }
    
    
}
