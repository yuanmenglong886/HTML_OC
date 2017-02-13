# HTML_OC
# 要点目录：
   1. UIWebView 时web和OC的交互方式
   2. WKWebView 时web和OC的交互方式
   3. 通过JS向native注入代码
   4. 基于UIWebView 的缓存加载
   5. 基于WKWebView 的缓存加载

## 一. UIWebView 和OC的交互方式

###  1.使用window.location.href 

      1)  在web  html 页面 使用 window.location.href  = "scheme://protocol"，发出调用native  的请求，
      2)  在使用UIWebView 的时候，拦截web想native 发出的请求时，在WebView的代理方法
         - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
   中进行 拦截request.URL.absoluteString 是否我们提前定义好的scheme和protocol  ,然后在native 进行相应的跳转
###  2.使用iFrame
    1）在Native 端和window.locaiton.href一样使用 webview的代理方法进行拦截，同时在native 端在页面加载完成后，通过 OC调用JS在html 的执行环境中生成一个供JS调用的全局函数  window.JSBridge.callFunction, 该函数生成一个iFrame的Dom节点，并给该节点设置属性
     iFrame.setAttribute(\"src\",URL), 并将该节点添加到当前document，然后移除该iFrame 节点，达到向Native 发出请求的作用
    2） 在web html中，只用需要向native 通信时，只用调用window.JSBridge.callFunction(\"callNativeFunction\", \"some data\")函数。
    3） native 在代理
    - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType: (UIWebViewNavigationType)navigationType
    方法中，进行相应的跳转和处理

###   3. 使用javascriptCore (苹果在iOS 7系统上公开了JavascriptCore,提供了JS 调用OCNative 的能力)
    1） 在Native 穿件UIWebView 后，通过 
    JSContext * jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    获取当前WebView 的 JavaScript 的运行环境，利用JavaScriptCore 提供的桥接方式 block 或者 JSExport 协议来将native的提供给JavaScirpt的接口导入当前的Javascript的运行环境
    2） 在 web  中，向native 通信时，调用前面Native 暴露给js 的借口，达到通信的作用
##  二.WKWebView 和OC交互的方式

### 1.使用iFrame  
    1）在iFrame 的代理方法
     - (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
    页面加载完成以后，在上面的代理方法中和UIWebView  中的iFrame一样，生成一个去全局的  window.JSBridge.callFunction
    2） Native 在WKWebview 的代理方法中
  - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
   进行拦截，并根据约定进行相关的处理

### 2.使用系统提供的 WKScriptMessageHandler代理协议进行和JS 进行交互

    1） native 端，WKwebView 添加相应的代理和name和 遵守这个协议，并实现相应的协议方法
    2）在JS中通过 window.webkit.messageHandlers.<name>.postMessage向Native通信

## 三.通过JS向Native 中注入代码

     利用JSPatch(基于javascrpit+runtime实现)在HMTL页面中向native 应用中动态的注入native代码，达到原声应用的效果 

## 四.基于UIWebView 的缓存加载    

### 1. 对用webview 系统提供了相应的接口 NSURLProtocol ，我们只用继承该类重新它的方法 ，配合URLSesssion 进行本地的缓存 

### 2. 在某一个HTML页面需要进行缓存的时候，进行相应的协议注册  ，在跳出该页面时，取消协议的注册

## 五.基于WKWebView 的缓存加载

###  1.由于iOS 系统没有向iOS 开发者开放 WKWebview  实现Native 缓存的接口，在公有的API下是无法实现利用NSURLProtocol来进行本地缓存的

###  2. 阅读WebKit 的源码不难发现 ,在 私有的API接口下也是实现了相应的接口 ，有用到NSURLProtocol ,在这里我们可以利用runtime 来动态的获取 当前的属性browsingContextController  cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class]; 使用该属性动态的去注册自动的协议registerSchemeForCustomProtocol
### 来达到类似于UIWebView 一样缓存的作用

### 在该案文章中 只是原理的概述，具体实现请移步：https://github.com/yuanmenglong886/HTML_OC
