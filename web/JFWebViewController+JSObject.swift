
//
//  Created by 绝非 on 2017/12/18.
//  Copyright © 2017年 绝非. All rights reserved.
//

import UIKit
import WebKit
import Photos

let XBKeyWindow = UIApplication.shared.keyWindow

extension JFWebViewController: JFWebViewProtocol {
    
    
    func shareByClient(_ shareInfo: String = "") {
        DispatchQueue.main.async {
            if let dict = shareInfo.jsonDictionary as? [String : String]{
                Caches.filter(imageUrl: dict["pic"], {[weak self] (i) in
                    let image = i.monkeyking_resetSizeOfImageData(maxSize: 127 * 1024)
                    let activity = UIActivityViewController.init(activityItems: [image!], applicationActivities: nil)
                    
                    if let popover = activity.popoverPresentationController {
                        popover.sourceView = self?.webView
                        popover.permittedArrowDirections = UIPopoverArrowDirection.up
                    }

                    self?.present(activity, animated: true, completion: nil)

                })
                
            }
        }
    }
    
    
    func saveImageToLocal(_ imageData: String) {
        DispatchQueue.main.async {
            if let d = imageData.components(separatedBy: ",").last,let data = Data.init(base64Encoded: d, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            {
                let index = UserDefaults.standard.integer(forKey: "WebImageIndex") + 1
                UserDefaults.standard.set(index, forKey: "WebImageIndex")
                UserDefaults.standard.synchronize()

                let savePath = NSHomeDirectory()  + "/Library/Caches/image\(index)"
                if  (data as NSData).write(toFile: savePath, atomically: true) {
                    self.webView?.evaluateJavaScript("\(self.callbackName ?? "")('\(savePath)');", completionHandler: nil)
                }else{
                    self.webView?.evaluateJavaScript("\(self.callbackName ?? "")('');", completionHandler: nil)
                }
                
            }
        }
    }

    
    func saveImageToAlbum(_ imageData: String) {

        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self] (granted) in
                DispatchQueue.main.async {
                    if (granted) {
                        self?.saveAlbum(imageData)
                    }else{
                        XBKeyWindow?.showToast("没有相册的存储权限")
                    }
                }
            })
        case .authorized: // 开启授权
            DispatchQueue.main.async {
                self.saveAlbum(imageData)
            }
            break
        default:
            DispatchQueue.main.async {
                XBKeyWindow?.showToast("没有相册的存储权限")
            }
            return
        }
    }
    
    func saveAlbum(_ imageData:String) {
        if let d = imageData.components(separatedBy: ",").last,let data = Data.init(base64Encoded: d, options: Data.Base64DecodingOptions.ignoreUnknownCharacters),let image = UIImage.init(data: data)
        {
            var localId = ""
            PHPhotoLibrary.shared().performChanges({
                let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let assetPlaceholder = result.placeholderForCreatedAsset
                //保存标志符
                localId = assetPlaceholder?.localIdentifier ?? ""
            }) {[weak self] (isSuccess: Bool, error: Error?) in
                if isSuccess {
                    
                    //通过标志符获取对应的资源
                    let assetResult = PHAsset.fetchAssets(
                        withLocalIdentifiers: [localId], options: nil)
                    let asset = assetResult[0]
                    let options = PHContentEditingInputRequestOptions()
                    options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData)
                        -> Bool in
                        return true
                    }
                    
                    DispatchQueue.main.async {
                        self?.webView?.evaluateJavaScript("\(self?.callbackName ?? "")('localId://\(localId)');", completionHandler: nil)
                    }
                    
                    //获取保存的图片路径
                    asset.requestContentEditingInput(with: options, completionHandler: {
                        (contentEditingInput:PHContentEditingInput?, info: [AnyHashable : Any]) in
                        XBLog(contentEditingInput!.fullSizeImageURL!)
                    })
                } else{
                    XBLog(error!.localizedDescription)
                     DispatchQueue.main.async {
                        if (error as! NSError).code == 2047 {
                            XBKeyWindow?.showToast("没有相册的存储权限")
                        }else{
                            self?.webView?.evaluateJavaScript("\(self?.callbackName ?? "")('');", completionHandler: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    func toast(_ message:String) {
        XBKeyWindow?.showToast(message)
    }
    
    func addShortcut(_ url:String) {
        guard let u = URL.init(string: url) else { return }
        if UIApplication.shared.canOpenURL(u) {
            UIApplication.shared.openURL(u)
        }
    }

    
    func openUrlByClient(_ url: String = "") {
        
        guard let u = URL(string:url) else { return }
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(u){
                UIApplication.shared.openURL(u)
            }
        }
        
    }



}
