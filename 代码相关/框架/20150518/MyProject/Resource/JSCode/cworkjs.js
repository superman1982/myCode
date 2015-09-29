(function(window, document, undefined) {
    if (window.CWORKJSBridge) {
        return;
    }
    var _readyMessageIframe,
		_setResultIframe,
    	_sendMessageQueue = [],
    	_callback_map = {},
    	_callback_count = 1000,
    	_CALLBACK_ID = 'callback',
    	_HANDLER = 'handler',
    	_PARAMETERS = 'parameters',
    	_QUEUE_HAS_MESSAGE = '_has_message',
    	_FETCH_MESSAGE_QUEUE = '_fetch_queue',
    	_CUSTOM_PROTOCOL_SCHEME = 'CWORKJSBridge';
    	
    function _createQueueReadyIframe(doc) {
    	_setResultIframe = doc.createElement('iframe');
		_setResultIframe.id = '__CWORKBridgeIframe_SetResult';
		_setResultIframe.style.display = 'none';
		doc.documentElement.appendChild(_setResultIframe);
		
		_readyMessageIframe = doc.createElement('iframe');
        _readyMessageIframe.id = '__CWORKJSBridgeIframe';
        _readyMessageIframe.style.display = 'none';
        doc.documentElement.appendChild(_readyMessageIframe);
    }

	function _call(handler, parameters, callback) {
        if (!handler || typeof handler !== 'string') {
            return;
        }
        var msgObj = {};
        msgObj[_HANDLER] = handler;
        
        if (typeof parameters === 'object') {
			msgObj[_PARAMETERS] = parameters;
        }

        if (typeof callback === 'function') {
        	var callbackID = (_callback_count++).toString();
        	
       		msgObj[_CALLBACK_ID] = callbackID;
			_callback_map[callbackID] = callback;
        }
		_sendMessage(msgObj);
    }

	function _sendMessage(message) {
		_sendMessageQueue.push(message);
		_readyMessageIframe.src = _CUSTOM_PROTOCOL_SCHEME + '://' + _QUEUE_HAS_MESSAGE;
    };
    // 提供给native调用,该函数作用:获取_sendMessageQueue返回给native,由于android不能直接获取返回的内容,所以使用url shouldOverrideUrlLoading 的方式返回内容
    function _fetchQueue() {

        var messageQueueString = JSON.stringify(_sendMessageQueue);  

        _sendMessageQueue = [];

		_setResultIframe.src = _CUSTOM_PROTOCOL_SCHEME + '://' + _FETCH_MESSAGE_QUEUE + '/' + messageQueueString;
    };
    //提供给native使用,
    function _handleMessageFromNative(message) {
    	var _callbackId = message[_CALLBACK_ID];
		if(typeof _callbackId === 'string' && typeof _callback_map[_callbackId] === 'function') {
			var jsonObj = null;
			var returnValue = message[_PARAMETERS];
			
			if (typeof returnValue === 'string') {
				try {
					jsonObj = JSON.parse(returnValue);
				} catch(e) {
					jsonObj = returnValue;
				}
			} else {
				jsonObj = returnValue;
			}
            _callback_map[_callbackId](jsonObj);
            delete _callback_map[_callbackId]; // can only call once
		}
    }
    var __CWORKJSBridge = {
        // public
        invoke:_call,
        call:_call,
        
        _fetchQueue: _fetchQueue,
        _handleMessageFromNative: _handleMessageFromNative,
//        _dispatchJSBridgeReady:_dispatchJSBridgeReady
    };
	window.CWORKJSBridge = __CWORKJSBridge;
	
	//Ready go
//	function _dispatchJSBridgeReady() {
		
//	}
//	if (window.CWORKJSBridge._hasInit) {
//			return;
//	}
	_createQueueReadyIframe(document);
//		window.CWORKJSBridge._hasInit = true;
		
	var readyEvent = document.createEvent('Events');
	readyEvent.initEvent('CWORKJSBridgeReady');
	document.dispatchEvent(readyEvent);
})(this, document);