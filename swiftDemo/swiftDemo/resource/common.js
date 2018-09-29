$(function(){
	showInfo("开始渲染btns")
	btnsInit()

	//显示屏幕宽高
	$(".screnn").html("宽："+document.body.clientWidth+" 高："+document.body.clientHeight )

})


var showInfo = function(msg){
	$(".info").html(msg);
}

var hi = function(){
	alert("hi")
	$(".info").html("hi");
}

var hello = function(msg){
	alert("hello " + msg)
	if(msg.obj != undefined)
		alert(msg.obj)
}

var getName = function(){
	return "juefei"
}


var btnsInit = function(){
	var btns = ["js原生alert劫持","调用ios的toast方法","调用ios的save方法并获取返回值"]
	$.each(btns,function(i,item){
		var btnHtml = "<a>" + item+"</a>"
		$(".btns").append(btnHtml)
	})
	$(".btns a").click(function(){
		var btnText = $(this).html()
		if (btnText ==btns[0]) {
			hi()
		}
		if (btnText ==btns[1]) {
			kf.toast('这是js调用客户端的toast')
		}
        if (btnText ==btns[2]) {
            kf.save('测试图片', function(imagePath) {
               //取得客户端回传的参数
               showInfo(imagePath)
            })
        }
	})	

	showInfo("html加载完成")
}
