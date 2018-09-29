
//
//  Created by 绝非 on 2017/12/18.
//  Copyright © 2017年 绝非. All rights reserved.
//

import UIKit
import WebKit

let XBKeyWindow = UIApplication.shared.keyWindow

extension JFWebViewController: JFWebViewProtocol {
    
    //公共方法实现

    func toast(_ message:String) {
        XBKeyWindow?.showToast(message)
    }

    
    //其他方法子类按需重写即可
    
    func save(_ image: String) {
        
    }

}
