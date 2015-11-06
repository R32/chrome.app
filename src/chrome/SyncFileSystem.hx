package chrome;

import chrome.Events;
import chrome.FileSystem;


@:enum abstract ServiceStatus(String) from String to String {
	var initializing = "initializing";
	var running = "running";
	var authentication_required = "authentication_required";
	var temporary_unavailable = "temporary_unavailable";
	var disabled = "disabled";
}

@:enum abstract FileStatus(String) from String to String {
	var synced = "synced";
	var pending = "pending";
	var conflicting = "conflicting";
}

@:enum abstract ConflictResolutionPolicy(String) from String to String {
	var last_write_win = "last_write_win";
	var manual = "manual";
}

@:enum abstract SyncAction(String) from String to String {
	var added = "added";
	var updated = "updated";
	var deleted = "deleted";
}

@:enum abstract SyncDirection(String) from String to String {
	var local_to_remote = "local_to_remote";
	var remote_to_local = "remote_to_local";
}

/**
在 Google 云端硬盘上保存和同步数据。该 API 并不是用来访问存储在 Google 云端硬盘上的任何用户文档的，它提供了应用专用的可同步存储区，用于离线和缓存用途，这样同样的数据就可以在不同的客户端间使用。有关使用该 API 的更多信息，请阅读管理数据。 

可用版本: chrome 27

权限: "syncFileSystem"
*/
@:require(chrome_app)
@:native("chrome.syncFileSystem")
extern class SyncFileSystem {
	/**
	返回由 Google 云端硬盘支持的同步文件系统，返回的 DOMFileSystem 实例可以以类似于临时和持久文件系统（参见 http://www.w3.org/TR/file-system-api/）的方式操作，但是返回的文件系统对象目前还不支持目录操作。您可以读取根目录，获取文件项列表（创建新的 DirectoryReader），但是不能在里面创建目录。在同一个应用中多次调用该方法会返回指向同一个文件系统的同一个句柄。
	
	注意，该调用可能会失败。例如，如果用户没有登录到 Chrome 或者没有网络连接。为了处理这些错误，您一定要在回调函数中检查 runtime.lastError。
	*/
	static function requestFileSystem( callback : DOMFileSystem->Void ) : Void;
	
	/**
	为应用设置同步文件存储的默认冲突解决策略，默认情况下为 'last_write_win'（手动）。当冲突解决策略设置为 'last_write_win' 时，已有文件的冲突在文件下一次更新时会自动解决。可以指定可选的 callback，以便知道请求是否成功。 
	*/
	static function setConflictResolutionPolicy( policy : ConflictResolutionPolicy, ?callback : Void->Void ) : Void;
	
	/**
	获取当前的冲突解决策略。 
	*/
	static function getConflictResolutionPolicy( callback : ConflictResolutionPolicy->Void ) : Void;
	
	/**
	返回该应用同步文件存储的当前用量与配额，以字节为单位。 
	*/
	static function getUsageAndQuota( fileSystem : DOMFileSystem, callback : {usageBytes:Int,quotaBytes:Int}->Void ) : Void;
	
	/**
	返回指定 fileEntry（文件项）的 FileStatus （文件状态），状态值可以为 'synced'（已同步）、'pending'（待定）或 'conflicting'（冲突）。注意，只有当服务的冲突解决策略设置为 'manual'（手动）时，才会发生 'conflicting'（冲突）状态。 
	*/
	static function getFileStatus( fileEntry : Entry, callback : FileStatus->Void ) : Void;
	
	/**
	返回指定 fileEntry（文件项）数组的每一个 FileStatus（文件状态），调用时通常传递 dirReader.readEntries() 的结果。 
	*/
	static function getFileStatuses( fileEntries : Array<Dynamic>, callback : Array<{fileEntry:Entry,status:FileStatus,?error:String}>->Void ) : Void;
	
	/**
	获取同步后端的当前状态。 
	*/
	static function getServiceStatus( callback : ServiceStatus->Void ) : Void;
	
	/**
	当同步后端发生错误或其他状态更改时产生（例如同步由于网络或认证错误而暂时不可用）。 
	*/
	static var onServiceStatusChanged(default,never) : Event<{state:ServiceStatus,description:String}->Void>;
	
	/**
	当文件由后台的同步服务更新时产生。 
	*/
	static var onFileStatusChanged(default,never) : Event<{fileEntry:FileEntry,status:FileStatus,?action:SyncAction,?direction:SyncDirection}->Void>;
}
