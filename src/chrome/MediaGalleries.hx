package chrome;

import js.html.Blob;
import chrome.Events;
import chrome.FileSystem.DOMFileSystem;

/**
mediaGalleries GetMediaFileSystemsInteractivity
 - no: 不要交互式地进行
 - yes: 询问用户管理允许的媒体库
 - if_needed: 只有当返回值会为空时才询问用户管理允许的媒体库
*/
@:enum abstract GetMediaFileSystemsInteractivity(String) from String to String {
	var no = "no";
	var yes = "yes";
	var if_needed = "if_needed";
}

typedef MediaFileSystemsDetails = {
	@:optional var interactive : GetMediaFileSystemsInteractivity;
}

/**
mediaGalleries MetadataOptions
 - all: 获取 MIME 类型、元数据标签以及附带的图片。
 - mimeTypeAndTags: 只获取 MIME 类型和元数据标签。
 - mimeTypeOnly: 仅获取 MIME 类型。
*/
@:enum abstract MetadataOptions(String) from String to String {
	var all = "all";
	var mimeTypeAndTags = "mimeTypeAndTags";
	var mimeTypeOnly = "mimeTypeOnly";
}

/**
mediaGalleries Metadata:
 - mimeType: 浏览器检测到的 MIME 类型。
 - height: 图片和视频会包含这些属性，以像素为单位。
 - width: 
 - xResolution: 图片会包含这些属性。
 - yResolution: 
 - duration: 音频和视频会包含该属性，以秒为单位。
 - rotation: 图片和视频会包含该属性，以度为单位
 - cameraMake: 图片会包含这些属性。
 - cameraModel: 
 - exposureTimeSeconds: 
 - flashFired: 
 - fNumber: 
 - focalLengthMm: 
 - isoEquivalent: 
 - album: 音频和视频会包含这些属性。
 - artist: 
 - comment: 
 - album: 
 - copyright: 
 - disc: 
 - genre: 
 - language: 
 - title: 
 - rawTags: 包含媒体文件中所有元数据的词典。如果文件格式包含多个媒体流，则按照媒体流的顺序表示，第一个元素是容器元数据
  - type: 描述媒体流的容器或编解码器格式，即 "mp3"、"h264" 等
  - tags: 媒体流的标签，以未经过滤的字符串->字符串词典的形式表示
 - attachedImages: 内嵌在媒体文件元数据中的图片，通常为艺术专辑或视频缩略图。
*/
typedef Metadata = {
	var mimeType : String;
	@:optional var height : Int;
	@:optional var width : Int;
	@:optional var xResolution : Float;
	@:optional var yResolution : Float;
	@:optional var duration : Float;
	@:optional var rotation : Int;
	@:optional var cameraMake : String;
	@:optional var cameraModel : String;
	@:optional var exposureTimeSeconds : Float;
	@:optional var flashFired : Bool;
	@:optional var fNumber : Float;
	@:optional var focalLengthMm : Float;
	@:optional var isoEquivalent : Float;
	@:optional var album : String;
	@:optional var artist : String;
	@:optional var comment : String;
	@:optional var copyright : String;
	@:optional var disc : Int;
	@:optional var genre : String;
	@:optional var language : String;
	@:optional var title : String;
	@:optional var track : Int;
	var rawTags : Array<{type:String,tags:Dynamic}>;
	var attachedImages : Array<Dynamic>;
}

/**
mediaGalleries ScanProgressType:
 - start: 扫描开始
 - cancel: 扫描取消
 - finish: 扫描完成，但是结果还没添加，您必须调用 addScanResults() 得到用户的许可。
 - error: 扫描遇到错误，不能继续进行
*/
@:enum abstract ScanProgressType(String) from String to String {
	var start = "start";
	var cancel = "cancel";
	var finish = "finish";
	var error = "error";
}

/**
mediaGalleries OnScanProgressEventDetails:
 - type: ScanProgressType
 - galleryCount: 找到的媒体库数目
 - audioCount: 找到的媒体文件的大致数目。某些文件类型既有可能是音频，也有可能是视频，在这两种类型中都会计算在内。
 - imageCount:
 - videoCount:
*/
typedef OnScanProgressEventDetails = {
	var type : ScanProgressType;
	@:optional var galleryCount : Int;
	@:optional var audioCount : Int;
	@:optional var imageCount : Int;
	@:optional var videoCount : Int;
}

/**
mediaGalleries GalleryChangedType:
 - contents_changed: 媒体库的内容已经更改
 - watch_dropped: 监视已经取消，因为设备已经弹出、媒体库权限取消或者其他原因
*/
@:enum abstract GalleryChangedType(String) from String to String {
	var contents_changed = "contents_changed";
	var watch_dropped = "watch_dropped";
}

/**
（在用户允许的前提下）访问用户本地磁盘中的媒体文件（音频、图片、视频）。

可用版本: chrome 23

权限: `{"mediaGalleries": ["accessType1", "accessType2", ...]}`,`{"mediaGalleries": ["accessType1", "accessType2", ..., "allAutoDetected"]}`

---

### 用法

让您提示用户，请求访问用户计算机上媒体库的权限。权限对话框包含当前平台上常用的媒体位置，并允许用户指定其他位置。在这些位置中，只有媒体文件才会在文件系统对象中出现

### 清单文件

媒体库 API 有两种权限参数：
 - 可以访问的位置
 - 访问类型
 
这两种类型以及每一种类型的权限参数如下表所述：

 - 位置: 无. 如果您不指定位置权限参数，只有在运行时用户使用媒体库权限对话框授予访问指定媒体库的权限后，才能访问媒体库。
 - 位置: "allAutoDetected". 授予您的应用访问用户计算机上所有自动检测到的媒体库的权限，该权限使得应用安装时显示提示，表示应用可以访问用户的媒体文件。

 - 访问类型: "read". 授予您的应用读取媒体库文件的权限。
 - 访问类型: "delete" 授予您的应用从媒体库删除文件的权限，"read" 权限是 "delete" 的前提条件，同时指定 "read" 与 "delete" 获得这两种访问媒体库的权限。
 - 访问类型: "copyTo" 授予您的应用向媒体库复制文件的权限，只允许 Chrome 浏览器能够播放或显示的有效媒体文件，复制 Chrome 浏览器无法验证的文件将导致安全错误。"read" 与 "delete" 权限是 "copyTo" 的前提条件，同时指定 "read"、"delete" 和 "copyTo" 获得媒体库的所有访问权限。
 
注意:
 - 媒体库权限对话框可以以编程方式触发。用户可能还有其他媒体位置，所以即使您指定了 "allAutoDetected" 权限，您也应当在您的应用中提供某种方式打开权限对话框。
 - 由于文件验证的要求，没有对媒体库的写入权限。然而，您可以将文件写入另一个文件系统，如临时文件系统，然后将这些文件复制到期望的媒体库中。
 - 访问类型权限本身不会触发安装时的提示，但是访问类型会在媒体库权限对话框和安装时的提示（如果请求了 "allAutoDetected" 权限）中反映出来

清单文件示例: 

```js
"permissions": [
	{ "mediaGalleries": ["read", "allAutoDetected"] }
],
```
 
[更多内容...](https://crxdoc-zh.appspot.com/apps/mediaGalleries)
*/
@:require(chrome_app)
@:native("chrome.mediaGalleries")
extern class MediaGalleries {
	/**
	获取当前用户的媒体库。如果没有配置或者没有可用的媒体库，回调函数将会接收空数组。 
	*/
	static function getMediaFileSystems( ?details : { ?interactive : GetMediaFileSystemsInteractivity }, callback : Array<DOMFileSystem>->Void ) : Void;
	
	/**
	chrome 34, 向用户显示选择文件夹对话框，并将选定目录添加为媒体库。如果用户取消对话框，selectedFileSystemName 为空。需要用户操作才能显示对话框，如果没有用户操作，调用回调函数时就像用户取消操作一样。 
	*/
	static function addUserSelectedFolder( callback : Array<DOMFileSystem>->String->Void ) : Void;
	
	/**
	chrome 36, 放弃指定媒体库的访问权限。 
	*/
	static function dropPermissionForMediaFileSystem( galleryId : String, ?callback : Void->Void ) : Void;
	
	/**
	chrome 35, 开始扫描用户的硬盘，寻找包含媒体的目录。扫描可能需要很长时间，所以进度和完成情况通过事件的方式通知。扫描完成后不会授予任何权限，而需要调用 addScanResults。 
	*/
	static function startMediaScan() : Void;
	
	/**
	chrome 35, 取消正在进行的媒体扫描，正常情况下应用应该提供某种方式让用户取消他们开始的扫描操作。 
	*/
	static function cancelMediaScan() : Void;
	
	/**
	向用户显示扫描的结果，并让他们将其中的一部分或者全部添加为媒体库。该方法应该在 'finish'（完成）类型的 onScanProgress 事件产生之后调用，调用后返回应用能够访问的所有媒体库，而不仅仅是新增加的媒体库。 
	*/
	static function addScanResults( callback : Array<DOMFileSystem>->Void ) : Void;
	
	/**
	chrome 26, 获取指定媒体文件系统的元数据。 
	*/
	static function getMediaFileSystemMetadata( mediaFileSystem : DOMFileSystem ) : {name:String,galleryId:String,?deviceId:String,isRemoveable:Bool,isMediaDevice:Bool,isAvailable:Bool};
	
	/**
	chrome 36, 获取所有可用媒体库的元数据 
	 - name: 文件系统的名称
	 - galleryId: 媒体库的唯一持久标识符。
	 - deviceId: 如果媒体库位于可移动设备上，并且设备在线，则为设备的唯一标识符
	 - isRemovable: 如果媒体库在可移动设备上则为 true。
	 - isMediaDevice: 如果检测到媒体库所在的设备是媒体设备（即 PTP 或 MTP 设备，或存在 DCIM 目录）则为 true。
	 - isAvailable: 如果设备当前可用则为 true。
	*/
	static function getAllMediaFileSystemMetadata( callback : Array<{name:String,galleryId:String,?deviceId:String,isRemovable:Bool,isMediaDevice:Bool,isAvailable:Bool}>->Void ) : {name:String,galleryId:String,?deviceId:String,isRemoveable:Bool,isMediaDevice:Bool,isAvailable:Bool};
	
	/**
	chrome 38 Dev, 获取媒体文件特定的元数据，媒体库和其他 DOM 文件系统中的文件都可以使用该方法。 
	*/
	static function getMetadata( mediaFile : Blob, ?options : MetadataOptions, callback : Metadata->Void ) : Void;		
	static function addGalleryWatch( galleryId : String, callback : {galleryId:String,success:Bool}->Void ) : Void;
	static function removeGalleryWatch( galleryId : String ) : Void;
	static function getAllGalleryWatch( callback : Array<String>->Void ) : Void;
	static function removeAllGalleryWatch() : Void;
	
	/**
	chrome 38 Dev. 媒体库更改时或取消媒体库监视时产生。 
	*/
	static var onGalleryChanged(default,never) : Event<{type:GalleryChangedType,galleryId:String}->Void>;
	
	/**
	chrome 35. 正在进行中的媒体扫描已经更改状态
	*/
	static var onScanProgress(default,never) : Event<OnScanProgressEventDetails->Void>;
}
