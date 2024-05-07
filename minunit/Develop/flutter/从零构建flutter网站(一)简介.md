# 从零构建flutter网站

[项目GIT](https://github.com/SOPD/lf_flutter_website)

## 简介

flutter支持web开发已有一段时间，使用flutter可以轻易开发出能够同时以手机app和网页形式同时存在的应用模块或是整个轻量型的应用。对于原生开发人员来说flutter上手难度极低，同时又能在接近0成本的情况下将native开发的经验用于html中，了解flutter for web将会是十分有用的。

## 优势与缺陷

​      如简介中所说 如果你是在设计一个轻量的app或者是app中的一个就像小程序那样的独立功能flutter  for web可以让你用自己的native经验无缝的完成开发，让hybrid更为轻松。原生/html一致性让你即使不能热更新也可以通过切换为web版在紧急情况下尽可能保证应用可用。

​     nativeless，使用通用的package 的支持也可以让你尽量再多端重复使用组件，并且集成起来相当便捷。一如当前应用构建serverless化融合业务与前端，使用flutter可以让我们尽可能地少写多遍功能相同的前端代码。

​     flutter  for web的缺陷也就包含了flutter的全部缺陷 包括 框架不成熟bug多，由于dvm的存在 天然会占用更多的初始内存 作为对比

![flutterweb内存](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/flutterweb内存.png)

![新浪财经内存](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/新浪财经内存.png)

可以看到新浪财经在页面内容更多的情况下 实际的内存占用是要少上许多的 这主要是由于flutter for web的项目框架需要完整的在js之上运行产生的。这在浏览器中劣势不算明显，但如果是内存寸土寸金的APP中一个视图栈内PUSH多个flutter web页面也许会让你的APP迅速崩溃。
而同时由于flutter 的html项目完整的运行在一个js项目中 每一个flutterWeb页都需要运行它。这意味着如果你是使用html开发的方式让多个页面以多个flutter web项目的方式存在那么每一个这样的页面都需要重新下载它的main.js 每个约1.6M 。

## 环境

一个最小的静态flutter web app只需要配置一台nginx或者apache并将flutter web页面复制到根目录就行了

### 安装服务器

需要一台公网服务器   腾讯CVM最便宜 1核2G 跑个小网页完全够了 只是1M的小水管略蛋疼

因为以前用过APACHE所以一开始我装了个apache 但是因为我们这个flutter web并不是一个传统的网站项目，而是更加近似于前后端分离的app端，为了能和手机通用经常需要在应用中直接访问远端，这里nginx配置反向代理更加方便所以换成了nginx，应用中只要把网络访问部分独立出来就可以做到手机与WEB大部分通用了。后面会细说。

购买服务器后登录 安装nginx [教程在这里](https://www.runoob.com/linux/nginx-install-setup.html)  我装了1.18的新版

### FlutterWeb环境

之前写native的时候我使用的vscode，不过我没用它开发web项目。这里android studio调试方便一些 使用 android studio 。

首先安装flutter环境 [查看](https://flutterchina.club/setup-windows/)

然后将flutter切换到beta版 并开启web模式

 ```bat
flutter channel beta
flutter upgrade
flutter config --enable-web
 ```

然后直接创建一个新的flutter application就并使用chrome运行就可以看到一个在WEB中运行的flutter样例了

![flutterdemon](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/flutterdemonew.png)

新的项目中 多了web文件夹并且调试设备也变成了chrome 以及chrome server

这里选择webserver模式并执行 好处一是写了新的代码只需要重新run并刷新网页 而不用重启chrome比较快，二是可以在我们启动的浏览器快捷方式处允许跨域请求

![flutterwebrun](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/flutterwebrun.png)

console会给出你服务器的地址 其实可以在任意浏览器中打开 ，但是为了保证兼容性 还是在chrome中打开

![flutterwebhelloworld](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/flutterwebhelloworld.png)

你的print此后会在浏览器的console中输出

![flutterwebcosole](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/flutterwebcosole.png)

接下来使用命令

```bat
flutter build web
```

构建web工程 然后到build文件夹中找到web文件夹

![build](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/build.png)

![web](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/web.png)

将web文件夹中的全部内容复制到nginx服务器的主web路径下或者放在你想要放的地方并给它指定一个访问路径就可以了

### 讲一点nginx配置的问题

先说下前面说要开启跨域，因为实际部署在服务器中web app可以通过nginx反向代理访问外部资源所以调试的时候相当于是访问跨域资源，所以要开启浏览器的跨域访问。

而我们也可以通过配置nginx响应头支持跨域请求。

nginx配置的问题有时候不太好搜

#### root和alias

root会将匹配到的访问路径拼接到指定的root路径之后,因此只能指定实际存在的文件夹路径或快捷方式
alias可以将访问连接中匹配到的路径段转换为另外一道路径
所以假如说有同类资源要区分不同路径访问的话可以用alias

![nginxconfig](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/nginxconfig.png)

比如这样 我把网页中访问的jpg资源放在 cosfs/images路径下 那么我需要配置.jpg匹配路径root 这样所有访问的以.jpg结尾的资源都会去/cosfs/images下去查找
而此时我又想让用户通过/image 的连接也能单独访问这个文件夹下的资源。由于实际不存在/image这个文件夹 所以用alias实际将/image/xxx这个路径转换为/cosfs/images/xxx。

#### 反向代理

解决访问域外资源问题 ，通过nginx 反向代理通过将域外资源转为域内连接即可
![proxy](https://webfileserver-1300714616.cos.ap-shanghai.myqcloud.com/images/proxy.png)

这样 访问你的服务器下/klinedata/xxx就相当于访问下面的....../history/xxx
