//
//  IframeViewController.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/7.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "IframeViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface IframeViewController ()<UIWebViewDelegate>
@property (nonatomic,weak) UIWebView *webView;
@property (nonatomic,weak) UILabel *titleLabel;
@end

@implementation IframeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self installWebView];
    // Do any additional setup after loading the view.
}

- (void)installWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:webView];
    
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"Iframe" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
           JSContext * contenx = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
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
 NSURL *url = [request URL];
NSString *urlStr = url.absoluteString;
return [self processURL:urlStr];
}
-(BOOL) processURL:(NSString *) url
{
    NSString *urlStr = [NSString stringWithString:url];
    NSString *protocolPrefix = @"bridge-js://invoke?";
    if ([[urlStr lowercaseString] hasPrefix:protocolPrefix])
    {
        urlStr = [urlStr substringFromIndex:protocolPrefix.length];
        urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        NSDictionary *callInfo = [NSJSONSerialization
                                JSONObjectWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]
                                options:kNilOptions
                                error:&jsonError];
        [self jsCallToNativeFunction:callInfo];

        return NO;
    }
    return YES;
}
- (void)jsCallToNativeFunction:(NSDictionary *)callInfo
{
        NSString *functionName = [callInfo objectForKey:@"functionname"];
        NSString * args = [callInfo objectForKey:@"args"];
        NSLog(@"%@", [callInfo objectForKey:@"args"]);
        if ([functionName isEqualToString:@"callNativeFunction"]) {
            [self nativeFunction:args];
        }
}
-(void)nativeFunction:(NSString*)args {
     NSLog(@"%@",args);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    //  OC  调用JS的方法
         self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
       JSContext * contenx = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
       NSLog(@"contenx:%@",contenx);
       NSString *result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"myFunc(\"callNativeFunction\", \"some data\");"]];
       NSLog(@"%@",result);
    
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
  [webView stringByEvaluatingJavaScriptFromString:js];
  //JS 调用OC的方法
  [webView stringByEvaluatingJavaScriptFromString:@"window.JSBridge.callFunction(\"callNativeFunction\", \"some data\", \"xiaoyuan\");"];
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
