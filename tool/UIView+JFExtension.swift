
//
//  Created by 绝非 on 2018/8/7.
//  Copyright © 2018年 绝非. All rights reserved.
//

import UIKit

extension UIView{
    
    func showActivity(_ message : String? = nil) {
        makeToastActivity(.center, message: message)
    }
    
    func hideActivity() {
        self.hideToastActivity()
    }
    
    func showToast(_ message:String?) {
        self.hideToastActivity()
        self.makeToast(message, point: CGPoint(x:self.width/2,y:self.height/2), title: nil, image: nil, completion: nil)
    }
}


//frame
extension UIView {
    
    /// X
    public var left: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    /// Y
    public var top: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    /// 右边界的X值
    public var right: CGFloat{
        get{
            return self.left + self.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
    
    /// 下边界的Y值
    public var bottom: CGFloat{
        get{
            return self.top + self.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    /// centerX
    public var centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    /// centerY
    public var centerY : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    /// width
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    /// height
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    
    /// origin
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.left = newValue.x
            self.top = newValue.y
        }
    }
    
    /// size
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}

extension String {
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    public var jsonDictionary: Any?{
        
        let jsonData:Data = self.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict
        }
        XBLog("字符串josn解析失败")
        return nil
    }
}

extension UIImage {
    func monkeyking_resetSizeOfImageData(maxSize: Int) -> Data? {
        
        if let imageData = UIImageJPEGRepresentation(self,1.0),
            imageData.count <= maxSize {
            return imageData
        }
        
        func compressedDataOfImage(_ image: UIImage?) -> Data? {
            
            guard let image = image else {
                return nil
            }
            
            let imageData = image.binaryCompression(to: maxSize)
            
            if imageData == nil {
                let currentMiniIamgeDataSize = UIImageJPEGRepresentation(self,0.01)?.count ?? 0
                let proportion = CGFloat(currentMiniIamgeDataSize / maxSize)
                let newWidth = image.size.width * scale / proportion
                let newHeight = image.size.height * scale / proportion
                let newSize = CGSize(width: newWidth, height: newHeight)
                
                UIGraphicsBeginImageContext(newSize)
                image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return compressedDataOfImage(newImage)
            }
            return imageData
        }
        return compressedDataOfImage(self)
    }
    
    private func binaryCompression(to maxSize: Int) -> Data? {
        
        var compressionQualitys = [CGFloat](repeating: 0, count: 100)
        var i = compressionQualitys.count + 1
        compressionQualitys = compressionQualitys.map { (_) -> CGFloat in
            let newValue = CGFloat(i) / CGFloat(compressionQualitys.count + 1)
            i -= 1
            
            return newValue
        }
        
        var imageData: Data? = UIImageJPEGRepresentation(self, 1)
        
        var outPutImageData: Data? = nil
        
        var start = 0
        var end = compressionQualitys.count - 1
        var index = 0
        
        var difference = Int.max
        
        while start <= end {
            
            index = start + (end - start) / 2
            
            imageData = UIImageJPEGRepresentation(self, compressionQualitys[index])
            
            let imageDataSize = imageData?.count ?? 0
            
            if imageDataSize > maxSize {
                
                start = index + 1
                
            } else if imageDataSize < maxSize {
                
                if (maxSize - imageDataSize) < difference {
                    difference = (maxSize - imageDataSize)
                    outPutImageData = imageData
                }
                
                if index <= 0 {
                    break
                }
                end = index - 1
            } else {
                break
            }
        }
        return outPutImageData
    }
}
