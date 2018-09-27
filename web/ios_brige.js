/**
 * Created by 绝非 on 2016/11/18.
 */

__functionIndexMap = {};

function calliOSFunction(namespace, functionName, args, callback) {
    if (!window.webkit.messageHandlers[namespace]) return;
    var wrap = {
        "method": functionName,
        "params": args
    };
    if (callback) {
        var callbackFuncName;
        if (typeof callback == 'function') {
            callbackFuncName = createCallbackFunction(functionName + "_" + "callback", callback);
        } else {
            callbackFuncName = callback;
        }
        wrap["callback"] = callbackFuncName
    }
    window.webkit.messageHandlers[namespace].postMessage(JSON.stringify(wrap));
}

function createCallbackFunction(funcName, callbackFunc) {
    if (callbackFunc && callbackFunc.name != null && callbackFunc.name.length > 0) {
        return callbackFunc.name;
    }

    if (typeof window[funcName + 0] != 'function') {
        window[funcName + 0] = callbackFunc;
        __functionIndexMap[funcName] = 0;
        return funcName + 0
    } else {
        var maxIndex = __functionIndexMap[funcName];
        var newIndex = ++maxIndex;
        window[funcName + newIndex] = callbackFunc;
        return funcName + newIndex;
    }
}


var kf = {};

kf.toast = function (message) {
    calliOSFunction("kf", "toast", message );
};

kf.close = function () {
    calliOSFunction("kf", "close");
};

kf.openUrlByClient = function (url) {
    calliOSFunction("kf", "openUrlByClient", url);
};

kf.shareByClient = function (shareInfo,callBackName) {
    calliOSFunction("kf", "shareByClient", shareInfo,callBackName);
};

kf.saveImageToAlbum = function (imageData,callBackName) {
    calliOSFunction("kf", "saveImageToAlbum",imageData,callBackName);
};

kf.saveImageToLocal = function (imageData,callBackName) {
    calliOSFunction("kf", "saveImageToLocal",imageData,callBackName);
};

kf.addShortcut = function (url) {
    calliOSFunction("kf", "addShortcut",url);
};


window["kf"] = kf;
