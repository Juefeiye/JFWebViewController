# JFWebViewController

使用

直接继承JFWebViewController，初始化JFWebview即可

            load(withUrl: "https://...")

如需使用toast，需要pod第三方NVActivityIndicatorView，也可以使用自己的toast组件

前端交互使用到kf对象，也可自行定义对象名称

前端代码示例

无回调:  
            
        kf.toast('这是提示') 

有回调:  

        kf.saveImageToLocal('this.base64', function(imagePath) { 
            
        // do something...
            
        } )
        
所有前端交互函数都使用协议JFWebViewProtocol来解决，方便使用和维护





