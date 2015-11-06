package chrome.system;

import chrome.Events;

typedef Bounds = {
	var left : Int;
	var top : Int;
	var width : Int;
	var height : Int;
}

typedef Insets = {
	var left : Int;
	var top : Int;
	var right : Int;
	var bottom : Int;
}

/**
查询显示器的元数据

可用版本: chrome 30

权限: "system.display"
*/
@:require(chrome_app)
@:native("chrome.system.display")
extern class Display {
	
	/**
	获取所有已连接显示设备的信息
	 - id: 显示器的唯一标识符
	 - name: 用户友好的名称（例如“HP LCD monitor”）
	 - mirroringSourceId: 在显示单元上镜像的显示器标识符，如果没有镜像则设为空字符串。当前仅在 Chrome OS 上可用，在其他平台上为空字符串。
	 - isPrimary: 如果是主显示器则为 true。
	 - isInternal: 如果是内部显示器则为 true
	 - isEnabled: 如果显示器已启用则为 true。
	 - dpiX: 沿着宽度方向每英寸的像素数目。
	 - dpiY: 沿着高度方向每英寸的像素数目
	 - rotation: 显示器相对与垂直位置顺时针转过的角度。目前仅在 Chrome OS 上可用，在其他平台上设置为 0
	 - bounds: 显示器的逻辑范围。
	 - overscan: 显示器在其屏幕范围内的位置。目前仅在 Chrome OS 上可用，在其他平台上为空
	 - workArea: 显示器在显示器范围内的可用工作区域，该工作区域不包括保留给操作系统（例如任务栏与执行器）的显示区域。
	*/
	static function getInfo( callback : Array<{
			id : String,
			name : String,
			mirroringSourceId : String,
			isPrimary : Bool,
			isInternal : Bool,
			isEnabled : Bool,
			dpiX : Float,
			dpiY : Float,
			rotation : Int,
			bounds : Bounds,
			overscan : Insets,
			workArea : Bounds
		}>->Void ) : Void;
		
	/**
	根据 info 中提供的信息更新 id 指定的显示器属性。如果失败会设置 runtime.lastError。
	 - mirroringSourceId: 如果设置了该参数并且不为空，开始当前显示器与指定标识符的显示器之间的镜像（系统会确定镜像哪一个显示器）。如果设置了该参数并且为空，停止当前显示器与指定标识符的显示器之间的镜像（如果正在镜像）。设置了该参数后，不能设置其他参数。
	 - isPrimary: 如果设置为 true，使当前显示器变成主显示器。设置为 false 则不进行任何操作。
	 - overscan: 如果设置了该参数，将显示器的过扫描设置为指定值。注意，过扫描值不能为负，也不能大于屏幕大小的一半，内部显示器的过扫描值不能更改。该参数在 isPrimary 参数之后应用。
	 - rotation: 如果设置了该参数，更新显示器的旋转角度，有效值包括 0、90、18、270，相对于显示器的垂直位置顺时针旋转。该参数在 overscan 参数之后应用
	 - boundsOriginX: 如果设置了该参数，更新显示器沿 x 轴方向的逻辑范围原点，如果设置了 boundsOriginY 的话与 boundsOriginY 同时应用。注意，更新显示器原点时可能会有一些约束，最终的范围原点可能与设置的不一样，最终的范围可以使用 getInfo 获取。范围原点在 rotation 之后应用，不能在主显示器上更改。注意，如果还设置了 isPrimary 就不能再设置范围原点值，因为首先应用 isPrimary 参数。
	 - boundsOriginY: 如果设置了该参数，更新显示器沿 y 轴方向的逻辑范围原点。参见 boundsOriginX
	*/
	static function setDisplayProperties( id : String, info : {
			?mirroringSourceId : String,
			?isPrimary : Bool,
			?overscan : Insets,
			?rotation : Int,
			?boundsOriginX : Int,
			?boundsOriginY : Int
		},
		?callback : Void->Void ) : Void;
		
	/**
	当显示器配置发生更改时 
	*/
	static var onDisplayChanged(default,never) : Event<Void->Void>;
}
