
//
//  Created by 绝非 on 2017/12/15.
//  Copyright © 2017年 绝非. All rights reserved.
//

import UIKit

@objc protocol JFWebViewProtocol:NSObjectProtocol{

    /*
     * 分享(new)
     * params: JSON
     * url:分享链接，   如果没有则转为分享图片
     * title:标题
     * description:描述
     * pic:图片
     * type:timeline,session,qq,zone
     * callback:success , fail, cancel
     */
    
    @objc optional func shareByClient(_ shareInfo:String)
    
    
    
    /*
     * 保存图片至相册
     * params: JSON
     * imageData : 图片base64之后的string
     *
     */
    @objc optional func saveImageToAlbum(_ imageData:String)
    
    /*
     * 保存图片至沙盒
     * params: JSON
     * imageData : 图片base64之后的string
     *
     */
    @objc optional func saveImageToLocal(_ imageData:String)
    
    
    /*
     * 保存快捷方式
     * params: JSON
     * url : safari 地址
     *
     */
    @objc optional func addShortcut(_ url:String)
    
    /*
     * toast
     * params: message
     * message
     *
     */
    @objc optional func toast(_ message:String)
    
    /*
     * 关闭网页
     */
    @objc optional func close()

    
}
