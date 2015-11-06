package chrome.system;

/**
获取网络接口信息。

可用版本: chrome 33

权限: "system.network" 
*/
@:require(chrome_app)
@:native("chrome.system.network")
extern class Network {
	/**
	获取当前系统中本地适配器的有关信息。
	 - name: 适配器的底层名称，在类 Unix 系统中通常为 "eth0"、"wlan0" 等等。
	 - address: 可用的 IPv4/6 地址。
	 - prefixLength: 前缀长度
	*/
    static function getNetworkInterfaces( callback : Array<{name:String,address:String,prefixLength:Int}>->Void ) : Void;
}
