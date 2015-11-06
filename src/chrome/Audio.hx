package chrome;

import chrome.Events;

typedef OutputInfo = {
	var id : String;
	var name : String;
	var isActive : Bool;
	var isMuted : Bool;
	var volume : Float;
}

typedef InputInfo = {
	var id : String;
	var name : String;
	var isActive : Bool;
	var isMuted : Bool;
	var gain : Float;
}

/**
允许用户获取连接到系统的音频设备信息，并控制它们。目前该 API 仅在 Chrome OS 上实现

可用版本: 仅用于 Dev 分支

权限: "audio"
*/
@:require(chrome_app)
@:require(chrome_dev)
@:native("chrome.audio")
extern class Audio {
	static function getInfo( callback : Array<OutputInfo>->Array<InputInfo>->Void ) : Void;
	static function setActiveDevices( ids : Array<String>, callback : Void->Void ) : Void;
	static function setProperties( id : String, properties : {isMuted:Bool,?volume:Float,?gain:Float}, callback : Void->Void ) : Void;
	static var onDeviceChanged(default,never) : Event<Void->Void>;
	static var onLevelChanged(default,never) : Event<String->Int->Void>;
	static var onMuteChanged(default,never) : Event<Bool->Bool->Void>;
}
