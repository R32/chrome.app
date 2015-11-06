package chrome;

/**
可用版本: Chrome 42

权限: "browser"
*/
@:require(chrome_app)
@:native("chrome.browser")
extern class Browser {
	static function openTab( options : {url:String}, ?callback : Void->Void ) : Void;
}
