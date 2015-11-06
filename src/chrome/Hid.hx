package chrome;

import js.html.ArrayBuffer;
import chrome.Events;

typedef HidDeviceInfo = {
	var deviceId : Int;
	var vendorId : Int;
	var productId : Int;
	var collections : Array<{usagePage:Int,usage:Int,reportIds:Array<Int>}>;
	var maxInputReportSize : Int;
	var maxOutputReportSize : Int;
	var maxFeatureReportSize : Int;
	var reportDescriptor : ArrayBuffer;
}

typedef DeviceFilter = {
	@:optional var vendorId : Int;
	@:optional var productId : Int;
	@:optional var usagePage : Int;
	@:optional var usage : Int;
}

/**
与连接的 HID 设备交互。使用该 API 您可以在应用中进行 HID 操作，应用可以作为硬件设备的驱动程序使用。

可用版本: chrome 38. 警告：目前为 Dev 分支

权限: "hid"
*/
@:require(chrome_app)
@:native("chrome.hid")
extern class Hid {
	/**
	根据制造商标识符/产品标识符/接口标识符枚举所有已连接的 HID 设备。 
	*/
	static function getDevices( options : {?vendorId:Int,?productId:Int,?filters:Array<DeviceFilter>}, callback : Array<HidDeviceInfo>->Void ) : Void;
	static function connect( deviceId : Int, callback : {connectionId:Int}->Void ) : Void;
	static function disconnect( deviceId : Int, callback : Void->Void ) : Void;
	static function receive( connectionId : Int, callback : Int->ArrayBuffer->Void ) : Void;
	static function send( connectionId : Int, reportId : Int, data : ArrayBuffer, callback : Void->Void ) : Void;
	static function receiveFeatureReport( connectionId : Int, reportId : Int, callback : ArrayBuffer->Void ) : Void;
	static function sendFeatureReport( connectionId : Int, reportId : Int, data : ArrayBuffer, callback : Void->Void ) : Void;
	static var onDeviceAdded(default,never) : Event<HidDeviceInfo->Void>;
	static var onDeviceRemoved(default,never) : Event<Int->Void>;
}
