package chrome;

import js.html.ArrayBuffer;
import chrome.Events;

@:enum abstract DataBits(String) from String to String {
	var seven = "seven";
	var eight = "eight";
}

@:enum abstract ParityBit(String) from String to String {
	var no = "no";
	var odd = "odd";
	var even = "even";
}

@:enum abstract StopBits(String) from String to String {
	var one = "one";
	var two = "two";
}

/**
chrome 33
 - persistent: 应用关闭时连接是否应该保持打开状态（参见Chrome 应用的生命周期），默认值为 false。应用加载时，之前使用 persistent: true 打开的串口连接可以通过 getConnections 获取。
 - name: 与连接相关联的字符串，由应用定义。
 - bufferSize: 用于接收数据的缓冲区大小，默认值为 4096。
 - bitrate: 打开连接时请求的比特率。为了尽可能地与各种硬件兼容，该数值应该匹配常用的比特率，例如 110、300、1200、2400、4800、9600、14400、19200、38400、57600、115200。当然，不能保证连接到串行端口的设备能支持请求的比特率，即使端口本身支持该比特率。默认为 9600。
 - dataBits: 默认为 "eight"。
 - parityBit: 默认为 "no"。
 - stopBits: 默认为 "one"
 - ctsFlowControl: 是否启用 RTS/CTS 硬件流控制，默认为 false。
 - receiveTimeout: 产生 "timeout"（超时）错误的 onReceiveError 事件前等待新数据的最长时间（以毫秒为单位）。如果为零，该连接不会产生接收超时错误。默认为 0。
 - sendTimeout: 调用回调函数产生 "timeout"（超时）错误前等待 send（发送）操作完成的最长时间（以毫秒为单位）。如果为零，不会产生发送超时错误。默认为 0。
*/
typedef ConnectionOptions = {
	@:optional var persistent : Bool;
	@:optional var name : String;
	@:optional var bufferSize : Int;
	@:optional var bitrate : Int;
	@:optional var dataBits : DataBits;
	@:optional var parityBit : ParityBit;
	@:optional var stopBits : StopBits;
	@:optional var ctsFlowControl : Bool;
	@:optional var receiveTimeout : Int;
	@:optional var sendTimeout : Int;
}

/**
ConnectionInfo: 一些值参考 ConnectionOptions 中的相同属性
 - connectionId: 串行端口连接标识符
 - paused: 是否阻止连接产生 onReceive 事件。
 - persistent: 
 - name: 
 - bufferSize: 
 - receiveTimeout: 
 - sendTimeout: 
 - bitrate: 参见 ConnectionOptions.bitrate。如果使用了非标准的比特率或者查询下层设备时产生错误，该字段可能不精确或省略
 - dataBits: 参见 ConnectionOptions.dataBits，如果查询下层设备时产生错误，该字段可能会省略
 - parityBit: 参见 ConnectionOptions.parityBit，如果查询下层设备时产生错误，该字段可能会省略
 - stopBits: 参见 ConnectionOptions.stopBits，如果查询下层设备时产生错误，该字段可能会省略
 - ctsFlowControl: 参见 ConnectionOptions.ctsFlowControl，如果查询下层设备时产生错误，该字段可能会省略
*/
typedef ConnectionInfo = {
	var connectionId : Int;
	var paused : Bool;
	var persistent : Bool;
	var name : String;
	var bufferSize : Int;
	var receiveTimeout : Int;
	var sendTimeout : Int;
	@:optional var bitrate : Int;
	@:optional var dataBits : DataBits;
	@:optional var parityBit : ParityBit;
	@:optional var stopBits : StopBits;
	@:optional var ctsFlowControl : Bool;
}

/**
SendInfo
 - disconnected: 连接已断开
 - pending: 发送操作正在进行
 - timeout: 发送操作超时
 - system_error: 发生系统错误，连接可能无法恢复
*/
@:enum abstract SendInfo(String) from String to String {
	var disconnected = "disconnected";
	var pending = "pending";
	var timeout = "timeout";
	var system_error = "system_error";
}

/**
SerialError:
 - disconnected: 连接已断开
 - timeout: 经过 receiveTimeout 毫秒后仍然未接收到数据
 - device_lost: 设备可能已经从主机断开
 - _break: 设备检测到中断条件
 - frame_error: 设备检测到帧错误
 - overrun: 字符缓冲区溢出发生。 下一个字符将丢失
 - buffer_overflow: 输入缓冲区溢出。 输入缓冲区满或在接收到结束符(EOF)后仍有字符
 - parity_error: 设备检测到奇偶校验错误
 - system_error: 发生系统错误，连接可能无法恢复
*/
@:enum abstract SerialError(String) from String to String {
	var disconnected = "disconnected";
	var timeout = "timeout";
	var device_lost = "device_lost";
	var _break = "break";
	var frame_error = "frame_error";
	var overrun = "overrun";
	var buffer_overflow = "buffer_overflow";
	var parity_error = "parity_error";
	var system_error = "system_error";
}

/**
读取和写入连接到串行端口的设备, [了解更多](https://crxdoc-zh.appspot.com/apps/app_usb)

可用版本: chrome 23

权限: "serial"
*/
@:require(chrome_app)
@:native("chrome.serial")
extern class Serial {
	/**
	返回系统中可用串行设备的有关信息，每次调用该方法时都会重新生成该列表。 
	*/
	static function getDevices( callback : Array<{path:String,?vendorId:Int,?productId:Int,?displayName:String}>->Void ) : Void;
	
	/**
	连接到指定的串行端口。 
	*/
	static function connect( path : String, ?options : ConnectionOptions, callback : ConnectionInfo->Void ) : Void;
	
	/**
	更新打开的串行端口连接的选项设置 
	*/
	static function update( connectionId : Int, options : ConnectionOptions, callback : Bool->Void ) : Void;
	
	/**
	断开串行端口连接。 
	*/
	static function disconnect( connectionId : Int, callback : Bool->Void ) : Void;
	
	/**
	暂停打开的连接，或取消暂停 
	*/
	static function setPaused( connectionId : Int, paused : Bool, callback : Void->Void ) : Void;
	
	/**
	获取指定连接的状态。 
	*/
	static function getInfo( connectionId : Int, callback : ConnectionInfo->Void ) : Void;
	
	/**
	获取当前应用拥有并打开的串行端口连接列表。 
	*/
	static function getConnections( callback : Array<ConnectionInfo>->Void ) : Void;
	
	/**
	向指定连接写入数据。 
	*/
	static function send( connectionId : Int, data : ArrayBuffer, callback : SendInfo->Void ) : Void;
	
	/**
	清洗指定连接输入输出缓存中的所有内容。 
	*/
	static function flush( connectionId : Int, callback : Bool->Void ) : Void;
	
	/**
	获取指定连接上控制信号的状态。
	
	 - dcd:（数据载波检测）或 RLSD（接收线信号检出）
	 - cts: 清除发送
	 - ri: 振铃指示
	 - dsr: 数据装置就绪
	*/
	static function getControlSignals( connectionId : Int, callback : {dcd:Bool,cts:Bool,ri:Bool,dsr:Bool}->Void ) : Void;
	
	/**
	设置指定连接上控制信号的状态
	
	 - dtr: 数据终端就绪。
	 - rts: 请求发送。
	*/
	static function setControlSignals( connectionId : Int, signals : {?dtr:Bool,?rts:Bool}, callback : Bool->Void ) : Void;
	
	/**
	暂停字符传输并将 transmission line 设为 break 状态直到调用 clearBreak 
	
	@Since Chrome 45
	*/
	static function setBreak( connectionId : Int, callback : Bool->Void ) : Void;
	
	/**
	恢复 setBreak
	
	@Since Chrome 45 
	*/
	static function clearBreak( connectionId : Int, callback : Bool->Void ) : Void;
	
	/**
	接收到数据时产生该事件。 
	*/
	static var onReceive(default, never) : Event<{connectionId:Int,data:ArrayBuffer}->Void>;
	
	/**
	运行时等待串行端口上的数据时如果发生错误，则产生该事件。产生该事件后，连接状态将设置为 paused（暂停）。"timeout"（超时）错误不会暂停连接。
	*/
	static var onReceiveError(default,never) : Event<{connectionId:Int,error:SerialError}->Void>;
}
