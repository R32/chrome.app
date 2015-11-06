package chrome;

import chrome.Events;

/**
在组播DNS上查询主机 

可用版本: chrome 31

权限: "mdns"
*/
@:require(chrome_app)
@:native("chrome.mdns")
extern class Mdns {
    static var MAX_SERVICE_INSTANCES_PER_EVENT(default,never) : Int;
	static function forceDiscovery( callback : Void->Void ) : Void;
	static var onServiceList(default,never) : Event<Array<{
            serviceName : String,
            serviceHostPort : String,
            ipAddress : String,
            serviceData : Array<String>
        }>->Void>;
}
