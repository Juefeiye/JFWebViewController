# JFWebViewController

使用 https://www.jianshu.com/p/afc52a5a28db

直接继承JFWebViewController，加载网页即可

        load(withUrl: "https://...")


前端交互使用到kf对象，也可自行定义对象名称

1.在ios_brige.js中定义交互方法

                    
        //无回调定义
        kf.toast = function (message) {
            calliOSFunction("kf", "toast", message );
        };
        
        //有回调定义
        kf.save = function(image,callBackName){
            calliOSFunction("kf","save",image,callBackName);
        };
                    
                    
2.在JFWebViewProtocol增加协议方法
所有前端交互函数都使用协议JFWebViewProtocol来解决，方便使用和维护

                
        @objc protocol JFWebViewProtocol:NSObjectProtocol{
        
        
                @objc optional func toast(_ message:String)
        
        
                @objc optional func save(_ image:String)
                
        
        }

3.实现协议方法


    
        extension JFWebViewController: JFWebViewProtocol {
        
                //公共方法实现
        
                func toast(_ message:String) {
                    XBKeyWindow?.showToast(message)
                }
        
        
                //其他方法子类按需重写即可
        
                func save(_ image: String) {
        
                }
        }


前端代码示例

无回调:  
            
        kf.toast('这是提示') 

有回调:  

        kf.save('imagebase64', function(imagePath) { 
            
        // do something...
            
        } )
        
客户端回调前端

        webView?.evaluateJavaScript("callbackName + ('这是ios回调给js的返回值');", completionHandler: nil)
        






