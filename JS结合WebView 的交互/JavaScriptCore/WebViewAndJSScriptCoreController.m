//
//  WebViewAndJSScriptCoreController.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/7.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "WebViewAndJSScriptCoreController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "JSCallOCBridge.h"
@interface WebViewAndJSScriptCoreController ()<UIWebViewDelegate>
@property (nonatomic,weak) UIWebView *webView;
@property (nonatomic,weak) UILabel *titleLabel;
@end

@implementation WebViewAndJSScriptCoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self installWebView];
    self.titleLabel.text = @"WebViewAndJSScriptCoreController";
    // Do any additional setup after loading the view.
}

- (void)installWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:webView];
        
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"WebViewJavascriptCore" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
           JSContext * jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [webView loadRequest:request];
    //  一  使用block  来完成js 互调OC
    ///////////////////////////////////////////
//            __weak typeof(self)weakSelf = self;
//        jsContext[@"blockjsCallNativeFunction"] = ^(NSDictionary *obj){
//        __strong typeof(weakSelf)strongSelf = self;
//        [strongSelf jsCallNativeFunction:obj];
//        };
    ////////////////////////////////////////////
    //  二  使用JavascriptCore  提供的JSExport 协议来进行
        JSCallOCBridge *bridge = [[JSCallOCBridge alloc]initWithContext:jsContext];
    
        jsContext[@"JSCallOCBridge"] = bridge;
        NSLog(@"willLoadContext=%@",jsContext);
//       NSLog(@"contenx:%@",contenx);
 
}
-(UILabel *)titleLabel{
    
    if (_titleLabel == nil) {
        UILabel * label  = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x-50, 0, 100, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor redColor];
        _titleLabel = label;
       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]init];
        self.navigationItem.titleView = _titleLabel;
    }
    return _titleLabel;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
      return YES;
}


-(void)nativeFunction:(NSString*)args {
     NSLog(@"%@",args);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //  OC  调用JS的方法
    //  1. 获取当前的JSContext 运行环境
       JSContext * jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
       NSLog(@"onloadcontenx:%@",jsContext);
    
    ////////////////////////////////////////////////
    // 一  使用block  来完成js 互调OC
    //    使用javaScript  和Native 代码进行互调;
//        __weak typeof(self)weakSelf = self;
//        jsContext[@"blockjsCallNativeFunction"] = ^(NSDictionary *obj){
//        __strong typeof(self)strongSelf = self;
//        [strongSelf jsCallNativeFunction:obj];
//        };

    ////////////////////////////////////////////////
    
    
    
    
    //  2. 获取本地执行的JS  脚本
//    NSString *jsPath = [[NSBundle mainBundle]pathForResource:@"WebViewJavascriptCore" ofType:@"js"];
//    NSString *jsContent = [[NSString alloc]initWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
//    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//       context.exception = exceptionValue;
//       NSLog(@"异常信息：%@", exceptionValue);
//   };
// 
//   [jsContext evaluateScript:jsContent];
   JSValue *jsResult =  [jsContext objectForKeyedSubscript:@"globalObject"];
   [jsResult invokeMethod:@"nativeCallJS" withArguments:@[@"yuanmenglong",@""]];
   jsContext[@"log"] = ^( id obj){
       NSLog(@"%@",obj);
   };
   [jsContext evaluateScript:@"log(\"yuanxiaofei\")"];
   
}
- (void)jsCallNativeFunction:(NSDictionary *)obj
{
      NSLog(@"%@",obj);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
