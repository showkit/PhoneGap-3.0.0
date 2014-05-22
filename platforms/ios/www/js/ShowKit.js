var ShowKit = {
    
    initializeShowKit: function (apiKey)
    {
        cordova.exec(null,null,"ShowKitPlugin","initializeShowKit",[apiKey]);
    }
    ,
    
    registerUser: function (callBack, username, password)
    {
        cordova.exec(callBack,callBack,"ShowKitPlugin","registerUser",[username, password]);
    }
    ,
    
    registerSubscriber: function (callBack, username, password)
    {
        cordova.exec(callBack,callBack,"ShowKitPlugin","registerSubscriber",[username, password]);
    }
    ,
    
    login: function (username, password)
    {
        cordova.exec(null,null,"ShowKitPlugin","login",[username, password]);
    }
    ,
    
    loginWithCompletion: function (callBack, username, password)
    {
        cordova.exec(callBack,callBack,"ShowKitPlugin","login",[username, password]);
    }
    ,
    
    initiateCallWithUser: function (username)
    {
        cordova.exec(null,null,"ShowKitPlugin","initiateCallWithUser",[username]);
    }
    ,
    initiateCallWithSubscriber: function (username)
    {
        cordova.exec(null,null,"ShowKitPlugin","initiateCallWithSubscriber",[username]);
    }
    ,
    
    acceptCall: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","acceptCall",[null]);
    }
    ,
    
    rejectCall: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","rejectCall",[null]);
    }
    ,
        
    hangupCall: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","hangupCall",[null]);
    }
    ,
    
    logout: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","logout",[null]);
    }
    ,
    
    setDeviceTorch: function (state)
    {
        cordova.exec(null,null,"ShowKitPlugin","setDeviceTorch",[state]);
    }
    ,
    
    enableConnectionStatusChangedNotification: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","enableConnectionStatusChangedNotification",[null]);
    }
    ,
    
    disableConnectionStatusChangedNotification: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","disableConnectionStatusChangedNotification",[null]);
    }    
    ,
    
    setState: function (key, value)
    {
        cordova.exec(null,null,"ShowKitPlugin","setState",[key, value]);
    }
    ,
    
    getState: function (callBack,key)
    {
        cordova.exec(callBack,callBack,"ShowKitPlugin","getState",[key]);
    }
    ,
    
    localNotification: function (message,soundName)
    {
        cordova.exec(null,null,"ShowKitPlugin","localNotification",[message, soundName]);
    }
    ,
    
    sendMessage: function (msg)
    {
        cordova.exec(null,null,"ShowKitPlugin","sendMessage",[msg]);
    }    
    ,
    
    hideMainVideoUIView: function (hide)
    {
        cordova.exec(null,null,"ShowKitPlugin","hideMainVideoUIView",[hide]);
    }
    ,
    
    hidePrevVideoUIView: function (hide)
    {
        cordova.exec(null,null,"ShowKitPlugin","hidePrevVideoUIView",[hide]);
    }
    ,
    
    hideMenuUIView: function (hide)
    {
        cordova.exec(null,null,"ShowKitPlugin","hideMenuUIView",[hide]);
    }
    ,
    
    parseConnectionState: function (array)
    {
        var state=new Object();
        state.value = array[0];
        state.callerUsername=array[1];
        state.errorCode = array[2];
        state.error = array[3];
        
        return state;
    }    
    ,
    
    disableUserMessageReceivedNotification: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","disableUserMessageReceivedNotification",[null]);
    }
    ,
    
    enableUserMessageReceivedNotification: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","enableUserMessageReceivedNotification",[null]);
    }
    ,
    
    enableRemoteClientStateChangedNotification: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","enableRemoteClientStateChangedNotification",[null]);
    }
    ,
    
    disableRemoteClientStateChangedNotification: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","disableRemoteClientStateChangedNotification",[null]);
    }    
};
