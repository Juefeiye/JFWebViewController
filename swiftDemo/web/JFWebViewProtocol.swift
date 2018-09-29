
//
//  Created by 绝非 on 2017/12/15.
//  Copyright © 2017年 绝非. All rights reserved.
//

import UIKit

@objc protocol JFWebViewProtocol:NSObjectProtocol{

    
    @objc optional func toast(_ message:String)
 

    @objc optional func save(_ image:String)

    
}
