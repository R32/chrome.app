
# Haxe Chrome App [![Build Status](https://travis-ci.org/tong/chrome.app.svg?branch=master)](https://travis-ci.org/tong/chrome.app)

Haxe/Javascript type definitions for [google chrome-apps](https://developer.chrome.com/apps/api_index).

API version: 46  

---

To install from haxelib run:  
```
$ haxelib install chrome-app
```

For packaged apps types see: https://github.com/tong/chrome.extension  

---

### Haxe Defines

* `-D chrome`  Required (added automatically when using from haxelib)
* `-D chrome_app`  Required (added automatically when using from haxelib)
* `-D chrome_os`  To access apis available on chrome-os only.
* `-D chrome_dev`  To access apis available on the dev channel only.
* `-D chrome_experimental`  To access experimental apis.


---

### zh_CN Progress

https://crxdoc-zh.appspot.com

 * app

  - [x] runtime 个人感觉除了 onLaunched 基本没别的用处.

  - [x] window  创建,控制 appWindow, 比如吸引用户注意或者获得焦点

 * sockets

  - [ ] tcp

  - [ ] tcpServer

  - [ ] udp

 * system

  - [x] display 查询显示器的元数据

  - [x] network 获取网络接口信息
  
 - [ ] audio 允许用户获取连接到系统的音频设备信息，并控制它们。用于 Dev 分支, 目前该 API 仅在 Chrome OS 上实现, 

 - [ ] bluetooth 使用 chrome.bluetooth API 连接到蓝牙设备. 警告：目前为 Beta 分支

 - [ ] bluetoothLowEnergy

 - [ ] bluetoothSocket

 - [x] browser (chrome 42), 用于访问chrome 浏览器, 但只有一个方法用于打开一个 Tab 的方法,

 - [x] fileSystem 在用户的本地文件系统中创建、读取、浏览、写入文件(补上原文件)

 - [ ] hid (Dev分支)与连接的 HID 设备交互。使用该 API 您可以在应用中进行 HID 操作，应用可以作为硬件设备的驱动程序使用。

 - [x] mdns 在组播DNS上查询主机

 - [x] mediaGalleries （在用户允许的前提下）访问用户本地磁盘中的媒体文件（音频、图片、视频）。

 - [x] serial 读取和写入连接到串行端口的设备

 - [ ] socket 从 Chrome 33 开始该 API **弃用** ,应该改用 sockets.udp、sockets.tcp 和 sockets.tcpServer

 - [x] syncFileSystem 用于在 Google 云端上保存和同步 app 的数据, (对国内来说几乎没用)
