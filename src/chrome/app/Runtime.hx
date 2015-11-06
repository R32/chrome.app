package chrome.app;

import chrome.Events;

private typedef FileEntry = Dynamic; //TODO

@:enum abstract Source(String) from String to String {
	var app_launcher = "app_launcher";
	var new_tab_page = "new_tab_page";
	var reload = "reload";
	var restart = "restart";
	var load_and_launch = "load_and_launch";
	var command_line = "command_line";
	var file_handler = "file_handler";
	var url_handler = "url_handler";
	var system_tray = "system_tray";
	var about_page = "about_page";
	var keyboard = "keyboard";
	var extensions_page = "extensions_page";
	var management_api = "management_api";
	var ephemeral_app = "ephemeral_app";
	var background = "background";
	var kiosk = "kiosk";
	var chrome_internal = "chrome_internal";
	var test = "test";
}

/**
管理应用的生命周期。应用运行时环境管理应用的安装，控制事件页面，并且可以在任何时候关闭应用

与世界上的所有事物一样，应用也有生命周期。它们会安装、运行、重新启动，在系统需要释放资源时会暂停，还会被卸载。该实验将向您展示 Chrome 应用生命周期的基础知识，以及它的核心——事件页面（即后台脚本）是如何使用的。

### onLaunched 事件

app.runtime.onLaunched 事件是最重要的事件，当用户为了执行而单击您的应用图标时产生。对于大多数较简单的应用来说，事件页面应该监听该事件并在它产生时打开一个窗口

```haxe
// Background.hx
chrome.app.Runtime.onLaunched.addListener(function(launchData){	
	chrome.app.Window.create("index.html", { 
		id: "index",
		outerBounds:{width: 500, height: 309}
	});	
});
```

### onRestarted 事件

app.runtime.onRestarted 事件不像 onLaunched 那样重要，但是它可能和 **某些类型的应用** 相关。当应用重新启动时，例如当 Chrome 浏览器退出、重新启动，再次运行应用时，将会执行该事件。您可以利用该事件恢复临时的状态。

例如，如果您的应用有一个表单，包含多个字段，您不会在用户输入时就保存部分的表单。如果用户特意退出您的应用，他们不一定希望保留这部分数据。如果 Chrome 运行时环境由于用户意图以外的原因重新启动，在应用重新启动时用户可能还需要这些数据。


```haxe
chrome.app.Runtime.onLaunched.addListener(function(){
	runApp(false)
});

chrome.app.Runtime.onRestarted.addListener(function(){
	runApp(true);
});

function runApp(readInitState:Bool){
	chrome.app.Window.create("index.html", { 
		id: "index",
		bounds: {width: 500, height: 309}
	}, function(win){
		readInitState ? win.contentWindow.setInitialState(): win.contentWindow.clearInitialState();
	});
}
```

@since 23
*/
@:require(chrome_app)
@:native("chrome.app.runtime")
extern class Runtime {
	/**
	其他应用请求嵌入该应用时产生。该事件仅在 Dev 分支上，并且指定 --enable-app-view 参数的情况下才可用
	
	@since 38 
	*/
	@:require(chrome_dev)
	static var onEmbedRequested(default,never) : Event<{
			?data : Dynamic,
			allow : String->Void,
			deny : Void->Void
		}->Void > ;
	
	/**
	应用从"起动器"执行时产生(这个事件仅用于用初使化创建应用窗口)
	`function(launchData:Object)`
	 - id: 调用应用的文件处理器标识符。处理器标识符为清单文件中 file_handlers 和/或 url_handlers 词典中的顶层键
	 - items: 匹配清单文件 file_handlers 中的文件处理器而触发的 onLaunched 事件的文件项
	  - entry: FileEntry
	  - type: 文件的 MIME 类型
	
	`function(?launchData:Object)`
	 - url: 匹配清单文件 url_handlers 中的 URL 处理器而触发的 onLaunched 事件的 URL。
	 - referrerUrl: 匹配清单文件 url_handlers 中的 URL 处理器而触发的 onLaunched 事件的引用 URL
	 - isKioskSession: 应用是否在 Chrome OS 信息亭模式下启动
	 - source: 应用是如何启动	 
	*/
	static var onLaunched(default, never) : Event < {	
		?id : String,
		?items : Array<{entry:FileEntry,type:String}>,
		?url : String,
		?referrerUrl : String,
		?isKioskSession : Bool,
		?source : Source	
	}->Void > ;

	/**
	当 Chrome 启动时产生，用于 Chrome 上一次关闭时正在运行的应用(但是目前即使关闭 chrome, app 都不会关闭)

	@since 24 
	*/
	static var onRestarted(default, never) : Event<Void->Void>;
}
