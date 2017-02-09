//
//  HrefViewController.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/7.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "HrefViewController.h"

@interface HrefViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIView *loadingView;
@end
/*
 test.html 村域服务器 ，里面的html和JS代码。。 我们是无法修改的
 如果texst.html 显示在手机端 ， 把哪个ul 去掉
 
 
 
 */
@implementation HrefViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. webView
    //http://t.dianping.com/shanghai?utm_source=baidubranding&utm_medium=baidu&utm_term=title&utm_content=&utm_campaign=wy-title
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
//    NSLog(@"%s",__FILE__);
    webView.frame= self.view.bounds;
    [self.view addSubview:webView];
    webView.backgroundColor = [UIColor redColor];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    //2 加载网页
//
//   NSString *path = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
//    NSLog(@"%@",path);
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"index" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSLog(@"%@",url);
    [webView loadRequest:request];
//    webView.hidden = YES;



}
//  OC 调用JS的代码    
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"currentURL:%@",currentURL);
    
}
//  html 和OC调用的方法         JS 调用OC代码用这个方法
// webView 每调用一次 ，都会掉用这个方法来监听请求    代理方法来监听这个请求 ，
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

  //  NSString *myurl = request.URL.absoluteURL;
    NSLog(@"request.URL.absoluteURL:%@",request.HTTPBodyStream);
    NSString *url = request.URL.absoluteString;
    NSLog(@"%@",url);
    NSRange range = [url rangeOfString:@"yml://"];
    NSInteger loc = range.location;
    if(loc != NSNotFound)// URL的协议头部是yml
    {
        // 方法名
        NSString *method = [url substringFromIndex:loc+range.length];
//        NSLog(@"%@",method);
        
        SEL sel = NSSelectorFromString(method);
        if([self respondsToSelector:sel])
        {
            [self performSelector:sel];
        }
        // 转成SEL的方法
        
    }
    
    return YES;
}
- (void)call
{
    NSLog(@"calll--------");
}
- (void)openCamera
{
    NSLog(@"openCamera ---------");
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
