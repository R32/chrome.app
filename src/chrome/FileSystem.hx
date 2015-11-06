package chrome;

import chrome.Events;

/**
EntryFlags: 
 - create: 如果不存在,则建立
 - exclusive: 与 create 一起使用. 如果 getFile 或 getDirectory 的目标路径已经存在,则将报错(即如果创建的文件已经存在,则报错)
*/
typedef EntryFlags = {
	?create:Bool,
	?exclusive:Bool
}

extern class EntryMetadata{
	var modificationTime(default, null):Date;
	var size(default, null):Float;	// unsigned long long
}

@:enum abstract WriteReadyState(Int) to Int{
	var INIT = 0;
	var WRITING = 1;
	var DONE = 2;
}

/**
http://dev.w3.org/2009/dap/file-system/file-dir-sys.html#idl-def-FileSystem
*/
extern class DOMFileSystem {	
	var name(default, null):String;
	var root(default, null):DirectoryEntry;
}

/**
http://dev.w3.org/2009/dap/file-system/file-writer.html 
*/
private extern class FileSaver extends js.html.EventTarget {
	var readyState(default, null):WriteReadyState;
	var error(default, null):js.Error;
	function abort():Void;
	var onabort:js.html.ProgressEvent-> Void;
	var onerror:js.html.ProgressEvent-> Void;
	var onprogress:js.html.ProgressEvent-> Void;
	var onwrite:js.html.ProgressEvent-> Void;
	var onwriteend:js.html.ProgressEvent-> Void;
	var onwritestart:js.html.ProgressEvent-> Void;
}

extern class FileWrite extends FileSaver{
	var position(default, null):Float;	// unsigned long long
	var length(default, null):Float;	// unsinged long long
	
	/**
	将 data 写入当前 position.
	 - 如果 readyState 为 WRITING, 将抛出 InvalidStateError 并终止操作
	*/
	function write(data:js.html.Blob):Void;
	
	/**
	设置 position 的值为 offset.
	 - 如果 readyState 为 WRITING, 将抛出 InvalidStateError 并终止操作
	 - 如果 position > length 将设 position 为 length
	 - 如果 position < 0, 将设 position 为 position + length;
	 - 如果仍旧 position < 0, 将设 position 为 0
	*/
	function seek(offset:Float):Void;
	
	/**
	更改文件的长度, 如果缩短了文件, 超出的部分将被丢弃。 如果扩展了文件数据将由 zero-padded 填充(这很可能将导至文本文件乱码).
	 - 如果 readyState 为 WRITING, 将抛出 InvalidStateError 并终止操作
	*/
	function truncate(size:Float):Void;
}

/**
http://dev.w3.org/2009/dap/file-system/file-dir-sys.html#the-entry-interface
*/
extern class Entry {
	/**
	从 root 到 entry 的绝对路径, (在Chrome app中感觉总是 "/" + name, 通过 chrome.fileSystem.getDisplayPath 获得真实路径)
	*/
	var fullPath(default, null):String;
	
	var isDirectory(default, null):Bool;
	
	var isFile(default, null):Bool;
	
	/**
	entry name, 不包含路径
	*/
	var name(default, null):String;
	
	/**
	entry 类型
	*/
	var filesystem(default, null):DOMFileSystem;
	
	/**
	Returns a URL that can be used to identify this entry(TODO: chrome app 中总是返回空字符串"") 
	*/
	function toURL():String;
	
	/**
	获得元数据. 
	*/
	function getMetadata(successCallback:EntryMetadata->Void, ?errorCallback:js.Error->Void):Void;
	
	/**
	获得 parent entry , 如果 entry 为文件系统的 root, 则 parent 为自身.(由于安全的问题, chrome app 中可能会禁止访问并报错)
	*/
	function getParent(successCallback:Entry->Void, ?errorCallback:js.Error->Void):Void;
	
	/**
	移动一个 entry 到一个新的位置。
	*/
	function moveTo(parent:DirectoryEntry, ?newName:String, ?successCallback:Entry->Void, ?errorCallback:js.Error->Void):Void;
	
	function copyTo(parent:DirectoryEntry, ?newName:String, ?successCallback:Entry->Void, ?errorCallback:js.Error->Void):Void;
	
	function remove(successCallback:Void->Void, ?errorCallback:js.Error->Void):Void;
}


extern class FileEntry extends Entry {
	/**
	创建一个新的与此 FileEntry 对应的 FileWriter
	*/
	function createWriter(successCallback:FileWrite->Void, ?errorCallback:js.Error->Void):Void;
	
	/**
	返回一个此 FileEntry 对应的 File 
	*/
	function file(successCallback:js.html.File->Void,?errorCallback:js.Error->Void):Void;
}

extern class DirectoryReader{
	function readEntries(successCallback:Array<Entry>->Void, ?errorCallback:js.Error->Void):Void;
}

extern class DirectoryEntry extends Entry {
	/**
	创建新的 DirectoryReader 读取当前目录中的 entries. 
	*/
	function createReader():DirectoryReader; // TODOs
	
	/**
	创建或获得指定文件 
	path: 绝对路径或相对于 DirectoryEntry
	
	options: 如果没有错误抛出, 将会在回调中返回相应的 FileEntry
	 - 如果  create 和 exclusive 都为 true, 以及路径已经存在,将抛出错误
	 - 如果 create 为 true, 以及路径不存在, 将会新建一个 0 字节的文件,并在回调中返回对应的 FileEntry
	 - 如果 create 不为 true, 以及路径不存在, 将抛出错误
	 - 如果 create 不为 true, 以及路径已经存在, 但它是个目录,将抛出错误
	*/
	function getFile(path:String, ?options:EntryFlags, ?successCallback:FileEntry->Void, ?errorCallback:js.Error->Void):Void;
	
	/**
	创建或获得指定目录
	*/
	function getDirectory(path:String, ?options:EntryFlags, ?successCallback:DirectoryEntry->Void, ?errorCallback:js.Error->Void):Void;
	
	/**
	删除目录及其包含的内容.
	*/
	function removeRecursively(successCallback:Void->Void, ?errorCallback:js.Error->Void):Void;
}

@:enum abstract ChildChangeType(String) from String to String {
	var created = "created";
	var removed = "removed";
	var changed = "changed";
}

typedef Volume = {
	var volumeId : String;
	var writable : Bool;
}

/**
chrome.FileSystem.chooseEntry()
 - type: 显示的提示类型，默认为 'openFile'（打开文件）
 - suggestedName: 展现给用户的推荐文件名，作为要读取或写入的默认文件名，该参数可选
 - accepts: 该文件打开器可选接受选项的列表，对最终用户来说，每一个选项都会呈现为唯一的分组
  - description: 这是该选项的可选文字描述。如果不存在的话，将会自动生成描述，通常包含扩充之后的有效扩展名列表（例如 "text/html" 将扩充为 "*.html, *.htm"）。
  - mimeTypes: 可接受的 MIME 类型，例如 "image/jpeg" 或 "audio/*"。mimeTypes 或 extensions 其中之一必须包含至少一个有效元素。
  - extensions: 可接受的扩展名，例如 ["jpg", "gif", "crx"]
 - acceptsAllTypes: 除了 accepts 字段中指定的选项外，是否接受所有文件类型，默认为 true。如果 accepts 字段未设置或没有包含有效的项，它始终会被重置为 true 。
 - acceptsMultiple: 是否接受多个文件，仅在 'openFile'（打开文件）和 'openWritableFile'（打开可写文件）时支持。如果该属性设置为 true，调用 chooseEntry 的回调函数时会传递文件项列表，否则传递单个文件项。
*/
typedef ChooseEntryOptions = {
	?type: ChooseEntryOptionsType,
	?suggestedName:String,
	?accepts:Array<{?description:String,?mimeTypes:Array<String>,?extensions:Array<String>}>,
	?acceptsAllTypes:Bool
}

typedef ChooseMultiEntryOptions = { > ChooseEntryOptions,
	acceptsMultiple:Bool
}

/**

 - openFile: 提示用户打开现有文件，并在成功后返回只读的 FileEntry（文件项）。从 Chrome 31 开始，如果应用程序拥有 "fileSystem" 之下的 "write" 权限，返回的 FileEntry 可写，否则只读。
 - openWritableFile: 提示用户打开现有文件，并在成功后返回可写的 FileEntry（文件项）。如果应用没有 'fileSystem' 下的 'write' 权限，使用这种类型的调用将会失败，产生运行时错误。
 - saveFile: 提示用户打开现有文件或新文件，并在成功后返回可写的 FileEntry（文件项）。如果应用没有 'fileSystem' 下的 'write' 权限，使用这种类型的调用将会失败，产生运行时错误。
 - openDirectory: 提示用户打开目录，并在成功后返回 DirectoryEntry（目录项）。如果应用程序没有 "fileSystem" 之下的 "directory" 权限，使用这种类型调用会失败，产生运行时错误。如果应用程序拥有 "fileSystem" 之下的 "write" 权限，返回的 DirectoryEntry 可写，否则只读。该类型在 Chrome 31 中新增。
*/
@:enum abstract ChooseEntryOptionsType(String) from String to String {
	var openFile = "openFile";
	var openWritableFile = "openWritableFile";
	var saveFile = "saveFile";
	var openDirectory = "openDirectory";
}

/**
在用户的本地文件系统中创建、读取、浏览、写入文件。应用可以通过该 API 在用户选定的位置读取和写入文件，例如文本编辑器应用可以使用该 API 读取和写入本地文档。所有失败信息都通过 runtime.lastError 通知。

可用版本: chrome 23

权限: "fileSystem", `{"fileSystem": ["write"]}`, `{"fileSystem": ["write", "retainEntries", "directory"]}`
*/
@:require(chrome_app)
@:native("chrome.fileSystem")
extern class FileSystem {
	/**
	获取 FileEntry 对象的显示路径。显示路径基于文件在本地文件系统上的完整路径，但是可能会为了显示的目的而使可读性更好。
	
	(由于 FileEntry 的 fullPath 为 "/", 这个方法能获得本地文件系统真实的路径+文件名)
	*/
	static function getDisplayPath( entry : Entry, callback : String->Void ) : Void;
	
	/**
	从另一个 Entry 获取可写的 Entry。如果应用程序没有 'fileSystem' 下的 'write' 权限则该方法会失败，产生运行时错误。如果项目为 DirectoryEntry（目录项），应用程序必须拥有 "fileSystem" 之下的 "directory" 权限，否则调用会失败。 
	*/
	static function getWritableEntry( entry : Entry, callback : Entry->Void ) : Void;
	
	/**
	获取该 Entry 对象是否可以写入的信息 
	*/
	static function isWritableEntry( entry : Entry, callback : Bool->Void ) : Void;
	
	/**
	让用户选择文件或目录,如果 options 指定了 `acceptsMultiple:true`, 则回调函数传递 Array<FileEntry>,
	*/
	@:overload(function(callback:FileEntry->Void):Void { } )
	@:overload(function(options:ChooseMultiEntryOptions,callback:Array<FileEntry>->Void):Void { } )
	static function chooseEntry( options :ChooseEntryOptions, callback : FileEntry->Void ) : Void;
	
	/**
	如果可以恢复则恢复指定标识符的文件项，否则该调用会失败，产生运行时错误。
	
	id: 通过 retainEntry() 获得这个标识符
	*/
	static function restoreEntry( id : String, callback : Entry->Void ) : Void;
	
	/**
	返回应用是否有权限恢复指定标识符的文件项。
	
	id: 通过 retainEntry() 获得这个标识符
	*/
	static function isRestorable( id : String, callback : Bool->Void ) : Void;
	
	/**
	返回一个标识符，可以传递给 restoreEntry 而重新获得指定文件项的访问。只能保留最近使用的 500 个项目，调用 retainEntry 和 restoreEntry 都算作使用。如果应用拥有 'fileSystem' 之下的 'retainEntries' 权限，项目将永久保留。否则，只有应用运行时或重新启动后才会保留。 
	*/
	static function retainEntry( entry : Entry ) : String;
	
	/**
	TODOS: 感觉好像只有 chrome os 才支持
	
	@since chrome 44 
	*/
	static function requestFileSystem( options : {volumeId:String,?writable:Bool}, callback : ?DOMFileSystem->Void ) : Void;
	
	/**
	TODOS: 感觉好像只有 chrome os 才支持
	
	@since chrome 44 
	*/
	static function getVolumeList( callback : Array<Volume>->Void ) : Void;
	
	/**
	TODOS: 感觉好像只有 chrome os 才支持
	
	@since chrome 44 
	*/
	static var onVolumeListChanged(default,never) : Event<Array<Volume>->Void>;
}
