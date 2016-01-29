# cordova-baidupush

baidupush cordova plugin 百度云推送cordova插件

This project is a Cordova plugin. 

It changes Baidu Yun Push's SDK for Android and iOS to a Cordova plugin. 


## How to install it?

	cordova plugin add cordova-plugin-baidupush
	or
	cordova plugin add https://github.com/EtherZhou/baidupush


## How to use it?
	
	//Start work, bind the ids
	window.baidupush.startWork("your baidu app id", function(info){
		//success callback
		//your code here
	});
	
	//Stop work, unbind the ids
	window.baidupush.stopWork(function(info){
		//your code here
	});
	
	//Resume work, re-bind the ids
	window.baidupush.resumeWork(function(info){
		//your code here
	});
	
	//Set tags
	window.baidupush.setTags(["football", "cake", "doctor"], function(info){
		//your code here
	});
	
	//Del tags
	window.baidupush.delTags(["football", "cake"], function(info){
		//your code here
	});
	
	//List tags
	window.baidupush.listTags(function(info){
		//your code here
	});
	
	//Listen notification arrived event, when a notification arrived, the callback function will be called
	window.baidupush.listenNotificationArrived(function(info){
		//your code here
	});
	
	//Listen notification clicked event, when a notification is clicked, the callback function will be called
	window.baidupush.listenNotificationClicked(function(info){
		//your code here
	});
	
	//Only for android
	//Listen message arrived event, when a message arrived, the callback function will be called	
	window.baidupush.listenMessage(function(info){
		//your code here
	});
	

The example of return json object:

	{
		type: "onBind",
		data:{
			requestId: 123456,
			errorCode: 0,
			appId: "123456",
			channelId: "123456",
			userId: "123456",
			deviceType: 3
		}
	}
