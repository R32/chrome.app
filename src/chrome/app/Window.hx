package chrome.app;

import chrome.Events;
import haxe.extern.EitherType;

typedef ContentBounds = {
	@:optional var top : Int;
	@:optional var left : Int;
	@:optional var width : Int;
	@:optional var height : Int;
}

typedef BoundsSpecification = {
	@:optional var left : Int;
	@:optional var top : Int;
	@:optional var width : Int;
	@:optional var height : Int;
	@:optional var minWidth : Int;
	@:optional var minHeight : Int;
	@:optional var maxWidth : Int;
	@:optional var maxHeight : Int;
}

typedef Bounds = {
	var left : Int;
	var top : Int;
	var width : Int;
	var height : Int;
	@:optional var minWidth : Int;
	@:optional var minHeight : Int;
	@:optional var maxWidth : Int;
	@:optional var maxHeight : Int;
	function setPosition(left:Int,top:Int) : Void;
	function setSize(width:Int,height:Int) : Void;
	function setMinimumSize(minWidth:Int,minHeight:Int) : Void;
	function setMaximumSize(maxWidth:Int,maxHeight:Int) : Void;
}

/**
FrameOptions:

 - type: 边框类型: "none" 或 "chrome"(默认). 如果使用 "none"，CSS 属性 -webkit-app-region 使应用窗口可以拖放

	> -webkit-app-region: drag 用于将区域标记为可拖放，no-drag 用于禁用嵌套元素上的这一样式
 
 - color: 允许设置边框颜色，只有边框类型为 chrome 时才能设置边框颜色
 - activeColor: 允许设置窗口处于活动状态时的边框颜色，只有当边框类型为 chrome 时才能设置边框颜色。
 - inactiveColor: 允许设置窗口处于不活动状态时的边框颜色，只有当边框类型为 chrome 时才能设置边框颜色. inactiveColor 必须和 color 同时使用。
 
@since 35
*/
typedef FrameOptions = {
	@:optional var type : FrameType;
	@:optional var color : String;
	@:optional var activeColor : String;
	@:optional var inactiveColor : String;
}

@:enum abstract WindowState(String) from String to String {
	var normal = "normal";
	var fullscreen = "fullscreen";
	var maximized = "maximized";
	var minimized = "minimized";
}

@:enum abstract FrameType(String) from String to String {
	var none = "none";
	var chrome = "chrome";
}

/**
chrome.app.window.create 的一个参数类型
 - id: 用于标识窗口的标识符，会用来记住窗口的大小与位置，当同一标识符的窗口再次打开时恢复原来的尺寸。如果创建窗口时另一个具有同样标识符的窗口已经存在，当前打开的窗口将获得焦点，而不会创建新窗口。
 - innerBounds: 用于指定窗口( **不包括** 边框大小) 的初始位置、初始大小和约束。如果还指定了 id 并且之前显示过匹配 id 的窗口，则使用记录下来的位置和大小。
  - 注意，窗口内外边框之间的距离由操作系统决定，所以 innerBounds 和 outerBounds 设置同样的属性值会导致错误。
 - outerBounds: 用于指定窗口( **包括** 边框大小) 的....(参考innerBounds)
 - minWidth: 从 Chrome 36 开始弃用,请使用 innerBounds 或 outerBounds。
 - minHeight: 从 Chrome 36 开始弃用
 - maxWidth: 从 Chrome 36 开始弃用
 - maxHeight: 从 Chrome 36 开始弃用
 - frame: 窗口类型, 在 Chrome 36 或更高版本中可以使用 FrameOptions 对象
 - bounds: 从 Chrome 36 开始弃用。请使用 innerBounds 或 outerBounds
 - alphaEnabled: 启用窗口背景透明，警告: 仅在 ash 中支持，需要 app.window.alpha 权限
 - state: 窗口的初始状态，允许使它在创建时就全屏、最大化或最小化。默认为 'normal'（正常）。
 - hidden: 如果为 true，该窗口创建后将处于隐藏状态，创建之后在该窗口上调用 show() 可以显示它。默认为 false
 - resizable: 如果为 true 的话，用户可以调整窗口的大小。默认为 true。
 - singleton: 从 Chrome 34 开始弃用。不再支持具有相同标志的多个窗口。
 - alwaysOnTop: 如果为 true，窗口会保持在其他大部分窗口之上。如果有多个这样的窗口，当前具有焦点的窗口会在前台。需要 "app.window.alwaysOnTop" 权限，默认为 false。
 - focused: 如果为 true，窗口创建后将获得焦点。默认为 true。
 - visibleOnAllWorkspaces: chrome 39+, 如果为 true, 并且平台支持, 窗口将在所有 workspaces 中可见.(???什么是 workspaces)
*/
typedef CreateWindowOptions = {
	@:optional var id : String;
	@:optional var innerBounds : BoundsSpecification;
	@:optional var outerBounds : BoundsSpecification;
	@:optional var minWidth : Int;
	@:optional var minHeight : Int;
	@:optional var maxWidth : Int;
	@:optional var maxHeight : Int;
	@:optional var frame : EitherType<FrameType,FrameOptions>;
	@:optional var bounds : ContentBounds;
	@:optional var alphaEnabled : Bool;
	@:optional var state : WindowState;
	@:optional var hidden : Bool;
	@:optional var resizable : Bool;
	@:optional var singleton : Bool;
	@:optional var alwaysOnTop : Bool;
	@:optional var focused : Bool;
	@:optional var visibleOnAllWorkspaces : Bool;
}

/**
应用窗口
*/
extern class AppWindow {
	/**
	使窗口获得焦点 
	*/
	function focus() : Void;
	
	/**
	使窗口进入全屏 
	*/
	function fullscreen() : Void;
	
	/**
	窗口是否处于全屏状态 
	*/
	function isFullscreen() : Bool;
	
	/**
	最小化窗口 
	*/
	function minimize() : Void;
	
	/**
	窗口是否为最小化 
	*/
	function isMinimized() : Bool;
	
	/**
	最大化窗口 
	*/
	function maximize() : Void;
	
	/**
	窗口是否为最大化 
	*/
	function isMaximized() : Bool;
	
	/**
	从 最大化,最小化,或全全屏状态恢复窗口
	*/
	function restore() : Void;
	
	/**
	吸引用户注意该窗口 
	*/
	function drawAttention() : Void;
	
	/**
	取消 drawAttention 的形为
	*/
	function clearAttention() : Void;
	
	/**
	关闭窗口 
	*/
	function close() : Void;
	
	/**
	显示窗口, 如果窗口已经可见则什么也不做 
	*/
	function show( ?focused : Bool ) : Void;
	
	/**
	隐藏窗口, 如果窗口已经隐藏则什么也不做. 
	*/
	function hide() : Void;
	
	/**
	检测 alwaysOnTop 是否为 true
	*/
	function isAlwaysOnTop() : Bool;
	
	/**
	需要 "app.window.alwaysOnTop" 权限
	*/
	function setAlwaysOnTop( alwaysOnTop : Bool ) : Void;
	
	/**
	设置 visibleOnAllWorkspaces 属性
	*/
	function setVisibleOnAllWorkspaces( alwaysVisible : Bool ) : Void;
	@:require(chrome_dev)
	function setInterceptAllKeys( wantAllKeys : Bool ) : Void;
	
	/**
	浏览器的 window 对象 
	*/
	var contentWindow : js.html.Window;
	
	/**
	标识符
	*/
	var id : String;
	
	/**
	不包括边框, chrome 36+ 
	*/
	var innerBounds : Bounds;
	
	/**
	包括边框, chrome 36+ 
	*/
	var outerBounds : Bounds;
	
	/**
	chrome 26,当窗口改变大小时产生 
	*/
	var onBoundsChanged(default, never) : Event<Void->Void>;
	
	/**
	chrome 26,当窗口关闭时产生。注意，您应该在正在关闭的窗口之外的其他窗口监听该事件，例如在后台网页中。因为窗口关闭并产生该事件时正处于销毁的过程中，并不是所有 API 在窗口的脚本上下文中都能正常工作。 
	*/
	var onClosed(default,never) : Event<Void->Void>;
	
	/**
	chrome 27,窗口全屏时产生 
	*/
	var onFullscreened(default, never) : Event<Void->Void>;
	
	/**
	chrome 26, 当最大化时
	*/
	var onMaximized(default, never) : Event<Void->Void>;
	
	/**
	chrome 26, 当最小化时
	*/
	var onMinimized(default, never) : Event<Void->Void>;
	
	/**
	chrome 26, 当窗口从最小化,最大化或全屏的状态恢复时产生 
	*/
	var onRestored(default,never) : Event<Void->Void>;
}

/**
创建窗口。窗口可以有框架，包含标题栏和大小控件，它们不和任何 Chrome 浏览器窗口关联

@since 23
*/
@:require(chrome_app)
@:native("chrome.app.window")
extern class Window {
	/**
	窗口的大小与位置可以以几种不同的方式指定。最简单的选择是什么都不指定，这种情况下会使用默认大小与平台相关的位置。
	
	要设置窗口的位置、大小和约束，您可以使用 innerBounds 或 outerBounds 属性。innerBounds 不包括窗口的装饰部分，而 outerBounds 包括窗口的标题栏和边框。注意，内界与外界之间的填充部分由操作系统决定，所以同时设置内外界是错误的（例如同时设置 innerBounds.left 和 outerBounds.left ）。
	
	如果要自动记录窗口的位置，您可以为它们提供标识符。如果窗口有标识符，该标识符将在窗口移动或调整大小时用于记录它的大小和位置。以后打开具有同样标识符的窗口时使用记录的大小和位置，而不是指定的大小和位置。如果您需要打开一个具有标识符的窗口，并且使用不同于记录的默认位置，您可以使它创建时隐藏，将它移动到期望的位置，然后显示它。
	
	callback: 在已创建窗口（子窗口）的 load 事件产生前在父窗口中调用，父窗口可以设置子窗口中的字段或函数，以便在 onload 中使用
	 - `function(appWin) { appWin.contentWindow.foo = function () { }; };`
	*/
	static function create( url : String, ?options : CreateWindowOptions, ?f : AppWindow->Void ) : Void;
	
	/**
	返回当前脚本对应的 AppWindow 对象, 也可以在另一个页面的上下文中调用,如:`otherWindow.chrome.app.window.current()` 
	*/
	static function current() : AppWindow;
	
	/**
	获得所有 AppWindow 
	*/
	static function getAll() : Array<AppWindow>;
	
	/**
	获得指定 AppWindow 
	*/
	static function get(id:String) : AppWindow;
	
	/**
	请使用 AppWindow 下的相应方法, 这个静态方法看上去像是个空函数
	
	static var onBoundsChanged(default,never) : Event<Void->Void>;
	static var onClosed(default,never) : Event<Void->Void>;
	static var onFullscreened(default,never) : Event<Void->Void>;
	static var onMaximized(default,never) : Event<Void->Void>;
	static var onMinimized(default,never) : Event<Void->Void>;
	static var onRestored(default,never) : Event<Void->Void>;
	*/
}
