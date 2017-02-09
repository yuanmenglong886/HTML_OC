//
//  QGWKWebViewController.m
//  Tool
//
//  Created by 58 on 16/7/21.
//  Copyright © 2016年 yuanmenglong. All rights reserved.
//

#import "QGWKWebViewController.h"
#import "NSURLProtocol+WebKitSupport.h"
#define ScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight  [[UIScreen mainScreen] bounds].size.height

static CGFloat addViewHeight = 500;   // 添加自定义 View 的高度
static BOOL showAddView = YES;        // 是否添加自定义 View
static BOOL useEdgeInset = NO;        // 用哪种方法添加自定义View， NO 使用 contentInset，YES 使用 div
static BOOL isHTML  = YES;     //  通过该值来控制   使用UIView还是 HTML
@interface QGWKWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat delayTime;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) UIView *addView;
@end

@implementation QGWKWebViewController
#pragma mark getter    
- (UIView *)addView {
    if (!_addView) {
        _addView = [[UIView alloc] init];
        _addView.backgroundColor = [UIColor redColor];
    }
    return _addView;
}
#pragma mark 类方法
+ (QGWKWebViewController *)qgWkWebViewControllerWithURL:(NSString *)requestURL target:(UIViewController *)targetController;
{
    QGWKWebViewController *qgWKWebViewVC = [[QGWKWebViewController alloc]init];
    qgWKWebViewVC.requestUrl = requestURL;
    if(targetController.navigationController != nil)
    {
        [targetController.navigationController pushViewController:qgWKWebViewVC animated:YES];
    }
    else
    {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:qgWKWebViewVC];
        [targetController presentViewController:nav animated:NO completion:nil];
    }
    return qgWKWebViewVC;
}
- (void)viewDidLoad
{
    [self configurationWKWebView];
    [self startRequest];
     [NSURLProtocol wk_registerScheme:@"https"];
}
- (void)configurationWKWebView
{
     //  1. 创建配置类
      WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    
       config.allowsAirPlayForMediaPlayback =YES;
        config.allowsInlineMediaPlayback = YES;
        config.allowsPictureInPictureMediaPlayback = YES;
    
     //   1.1  偏好设置配置   iOS 的配置
    
     config.preferences = [[WKPreferences alloc]init];
     config.preferences.minimumFontSize = 10;
     config.preferences.javaScriptEnabled = YES;
     config.preferences.javaScriptCanOpenWindowsAutomatically = YES;

   //  1.2 配置web 内容处理池
    config.processPool = [[WKProcessPool alloc]init];
    
    // 1.3  配置JS 与webView的交互对象
     config.userContentController = [[WKUserContentController alloc]init];
     //  第一种方式： 自己遵循协议
    ////////////////////////////////////////
        #pragma mark     WKScriptMessageHandler
        [config.userContentController addScriptMessageHandler:self name:@"JSbridge"];
    
    ///////////////////////////////////////
     WKWebView *wk = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
     wk.allowsBackForwardNavigationGestures = YES;
    
    wk.UIDelegate = self;
    wk.navigationDelegate = self;
    wk.scrollView.delegate = self;
    [self.view addSubview:wk];
    self.webView = wk;
    //2 配置进度条
    UIProgressView *progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 2)];
    [self.view addSubview:progress];
    self.progressView = progress;
    self.progressView.progressTintColor = [UIColor blueColor];
    self.progressView.trackTintColor = [UIColor clearColor];
       NSKeyValueObservingOptions observingOptions = NSKeyValueObservingOptionNew;
    // KVO 监听属性，除了下面列举的两个，还有其他的一些属性，具体参考 WKWebView 的头文件
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:observingOptions context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:observingOptions context:nil];
    
    // 监听 self.webView.scrollView 的 contentSize 属性改变，从而对底部添加的自定义 View 进行位置调整
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:observingOptions context:nil];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http:www.baidu.com"]];
    [wk loadRequest:request];
}
- (void)dealloc
{
   [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
   [self.webView removeObserver:self forKeyPath:@"title"];
   [self.webView removeObserver:self forKeyPath:@"contentSize"];
   [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"JSbridge"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress < 1.0) {
            self.delayTime = 1 - self.webView.estimatedProgress;
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.progress = 0;
        });
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.contentHeight != self.webView.scrollView.contentSize.height) {
            self.contentHeight = self.webView.scrollView.contentSize.height;
            self.addView.frame = CGRectMake(0, self.contentHeight - addViewHeight, ScreenWidth, addViewHeight);
            NSLog(@"----------%@", NSStringFromCGSize(self.webView.scrollView.contentSize));
        }
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.webView evaluateJavaScript:@"parseFloat(document.getElementById(\"AppAppendDIV\").style.width);" completionHandler:^(id value, NSError * _Nullable error) {
        NSLog(@"======= %@", value);
    }];
}


- (void)startRequest
{
    if(self.requestUrl == nil)
    {
        return;
    }
    NSURL *url = [NSURL URLWithString:self.requestUrl];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
//    NSURL *pathURL = [[NSBundle mainBundle] URLForResource:@"WKWebView" withExtension:@"html"];
//        request = [NSURLRequest requestWithURL:pathURL];
    [self.webView loadRequest:request];
}
#pragma mark UIDelegate
//     在当前的window 窗口中打开新的窗口时  _blank
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
  WKFrameInfo *frameInfo = navigationAction.targetFrame;
  if (![frameInfo isMainFrame]) {
      [webView loadRequest:navigationAction.request];
  }
    return nil;
//      NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
//    WKWebView *wkWebView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
//    return wkWebView;
}

- (void)webViewDidClose:(WKWebView *)webView
{
    NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}
//  使用wekwebView，要想alert confirm  等，必须实现  UIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"确认框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [confirm addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          NSLog(@"点击确定按钮");
          completionHandler(YES);
     }]];
     [confirm addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         NSLog(@"点击取消按钮");
         completionHandler(NO);
     }]];
     [self presentViewController:confirm animated:YES completion:NULL];
    
     NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    UIAlertController *input = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [input addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.textColor = [UIColor blackColor];
        textField.placeholder = defaultText;
    }];
    [input addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击确定按钮");
         completionHandler([input.textFields lastObject].text);
    }]];
    [input addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         NSLog(@"取消");
         completionHandler(@"取消");
    }]];
    
    [input addAction:[UIAlertAction actionWithTitle:@"销毁" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
           completionHandler(@"销毁");
    }]];
    [self presentViewController:input animated:YES completion:nil];
    NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}
/////
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo
{
    NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
     return YES;
}
- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions
{
    NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
     return nil;
}
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController
{
    NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}





#pragma mark UINavgationDelegate
// 页面开始加载时调用     2客户端开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
    NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}
// 内容开始返回时调用  5. 正常调用开始返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
     NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}
// 页面加载完成时调用   6.加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"didFinishNavigation   ====    %@", navigation);
    
    if (!showAddView) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      if(!isHTML)
      {
       [self.webView.scrollView addSubview:self.addView];
      }
        
        if (useEdgeInset) {
            // url 使用 test.html 对比更明显
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, addViewHeight, 0);
        } else {
        
        //  第一种方式通过HTML中操作DOM来创建 DIV
            NSString *js = [NSString stringWithFormat:@"\
                            var appendDiv = document.getElementById(\"AppAppendDIV\");\
                            if (appendDiv) {\
                            appendDiv.style.height = %@+\"px\";\
                            } else {\
                            var appendDiv = document.createElement(\"div\");\
                            appendDiv.setAttribute(\"id\",\"AppAppendDIV\");\
                            appendDiv.style.width=%@+\"px\";\
                            appendDiv.style.height=%@+\"px\";\
                            appendDiv.style.backgroundColor = \"blue\";\
                            appendDiv.style.margin = \"0px 0px\"; \
                            document.body.appendChild(appendDiv);\
                            }\
                            ", @(addViewHeight), @(ScreenWidth-40), @(addViewHeight)];
            [self.webView evaluateJavaScript:js completionHandler:^(id value, NSError *error) {
                // 执行完上面的那段 JS, webView.scrollView.contentSize.height 的高度已经是加上 div 的高度
                  //  第二种方式添加UIView 的形式来view
                self.addView.frame = CGRectMake(0, self.webView.scrollView.contentSize.height - addViewHeight, ScreenWidth, addViewHeight);
            }];
        }
    });
    #pragma mark  Iframe  injection
     [self injectioniFrameJavascriptToWkWebView:self.webView];
     NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}
// 页面加载失败时调用    加载失败第四步5.
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
     NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}
//     4. 客户端收到服务端的相应头
//这个代理方法表示客户端收到服务器的响应头，根据reponse 相关信息，可以决定这次跳转是否可以继续进行
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{

   WKNavigationResponsePolicy responsePolicy = WKNavigationResponsePolicyAllow;
   NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));

     NSHTTPURLResponse *httpResponse =  navigationResponse.response;
     if([httpResponse statusCode] == 200)
     {
         responsePolicy = WKNavigationResponsePolicyAllow;
     }else
     {
          responsePolicy = WKNavigationResponsePolicyCancel;
     }
     NSLog(@"%@",httpResponse);
    decisionHandler(responsePolicy);
    NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));

}
#pragma mark    WKNavigationDelegate
// 在服务器发送请求之前，决定是否跳转
/**
 *  1.  类似于 UIWebview 的 shouldstartLoad
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    WKNavigationAction *action = navigationAction;
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
   NSLog(@"%@",action.request.URL.absoluteString);
   if([action.request.URL.absoluteString hasPrefix:@"bridge-js://"])
   {
   #pragma mark  Iframe  intercept
           [self interceptRequest:action.request];
            decisionHandler(WKNavigationActionPolicyCancel);
           return;
   }
   
//     NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
     //if([action.request.URL.absoluteString hasPrefix:@"https"])
//     if(navigationAction.navigationType == WKNavigationTypeLinkActivated)
//     {
//         policy =WKNavigationActionPolicyAllow;
//     }else
//     {
//         policy = WKNavigationActionPolicyCancel;
//     }
    decisionHandler(policy);
        NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}
// 接受到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
     NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}





// 页面加载是失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
        NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}
//       3  6
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    //challenge.protectionSpace.authenticationMethod
    if(challenge.protectionSpace.isProxy)
    {
      
    }
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    
    CFDataRef exceptions = SecTrustCopyExceptions(serverTrust);
    SecTrustSetExceptions(serverTrust, exceptions);
    CFRelease(exceptions);
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,
                      [NSURLCredential credentialForTrust:serverTrust]);
//    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,NULL);
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSString *progressmu = [NSString stringWithFormat:@"%f",webView.estimatedProgress];
      NSLog(@"%@,%s,%@",webView,__func__,NSStringFromSelector(_cmd));
}
#pragma mark     1. WKWebview  中 JS与Native 的通信    使用WKScriptMessageHandler delegate
#pragma  mark  WKScriptMessageHandler delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
         NSDictionary *dic = [NSDictionary dictionaryWithDictionary:message.body];
    NSLog(@"JS交互参数：%@", dic);
           dispatch_async(dispatch_get_main_queue(), ^{
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"0001"]) {
                NSString *js = [NSString stringWithFormat:@"globalCallback(\'%@\')",[UIDevice currentDevice].systemVersion];
                
                [self.webView evaluateJavaScript:js completionHandler:nil];
            } else {
                return;
            }
        });
}

#pragma  mark    2. WkWebView中使用Iframe 与JS 通信

#pragma mark  wkwebView 中测试  iFrame  来进行 JS和OC 的互调
- (void)injectioniFrameJavascriptToWkWebView:(WKWebView *)wkWebView
{
          NSString *js = @"(function() {\
                        window.JSBridge = {};\
                        window.JSBridge.callFunction = function(functionName, args){\
                        var url = \"bridge-js://invoke?\";\
                        var callInfo = {};\
                        callInfo.functionname = functionName;\
                        if (args)\
                        {\
                        callInfo.args = arguments;\
                        }\
                        url += JSON.stringify(callInfo);\
                        var rootElm = document.documentElement;\
                        var iFrame = document.createElement(\"IFRAME\");\
                        iFrame.setAttribute(\"src\",url);\
                        rootElm.appendChild(iFrame);\
                        iFrame.parentNode.removeChild(iFrame);\
                        };\
                        return true;\
                        })();";
     [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
         
     }];
}
- (NSString *)URLDecodedString:(NSString *)url
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)url, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    // NSString *str = [shareContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return decodedString;
}
- (void)interceptRequest:(NSURLRequest *)request
{
    
    NSLog(@"interceptRequest:%@",[self URLDecodedString:request.URL.absoluteString]);
}




@end
