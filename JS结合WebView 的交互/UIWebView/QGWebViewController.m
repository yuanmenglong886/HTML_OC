//
//  QGWebViewController.m
//  Tool
//
//  Created by 58 on 16/7/19.
//  Copyright © 2016年 yuanmenglong. All rights reserved.
//

#import "QGWebViewController.h"


@interface QGWebViewController()<UIWebViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *httpsUrlConnection;
@property (nonatomic, assign) BOOL httpsAuth;
@property (nonatomic, strong) NSURLRequest *originRequest;


@end


@implementation QGWebViewController
#pragma mark  getter 
//- (NSURLConnection *)httpsUrlConnection
//{
//    if(_httpsUrlConnection == nil)
//    {
//      _httpsUrlConnection = [[NSURLConnection alloc]initWithRequest:self.originRequest delegate:self];
//     }
//     return _httpsUrlConnection;
//}
//- (NSURLRequest *)originRequest
//{
//    if(_originRequest == nil)
//    {
//       NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
//       NSURLRequest *request = [NSURLRequest requestWithURL:url];
//       _originRequest = request;
//    }
//    return _originRequest;
//}
+ (QGWebViewController *)qgWebViewControllerWithURL:(NSString *)requestURL target:(UIViewController *)targetController
{
    QGWebViewController *qgWebViewVC = [[QGWebViewController alloc]init];
    qgWebViewVC.requestUrl = requestURL;
    if(targetController.navigationController != nil)
    {
        [targetController.navigationController pushViewController:qgWebViewVC animated:YES];
    }
    else
    {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:qgWebViewVC];
        [targetController presentViewController:nav animated:NO completion:nil];
    }
    return qgWebViewVC;
}
- (void)viewDidLoad
{
    [self configurationWebView];
    [self startRequest];
    
}
- (void)configurationWebView
{
 
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame
    .size.width, self.view.frame.size.height)];
//    webView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:webView];
    self.webView = webView;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
}
- (void)startRequest
{
    if(self.requestUrl == nil)
    {
        return;
    }
    NSURL *url = [NSURL URLWithString:self.requestUrl];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.webView loadRequest:request];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //  进行HTTPS认证
    /*
    if(!self.httpsAuth)
    {
        self.originRequest = request;
        self.httpsUrlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [self.httpsUrlConnection start];
    }
    */
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
 

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}
#pragma mark  UIWebView 进行权限认证的方式
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    if ([navigationAction.request.URL.absoluteString containsString:@"https://"] && IOSVersion < 9.0 && !self.httpsAuth) {
//        self.originRequest = navigationAction.request;
//        self.httpsUrlConnection = [[NSURLConnection alloc] initWithRequest:self.originRequest delegate:self];
//        [self.httpsUrlConnection start];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

//    2.  进行HTTPS认证
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        self.httpsAuth = YES;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

 //    3.加载

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.httpsAuth = YES;
    [self.webView loadRequest:self.originRequest];
    [self.httpsUrlConnection cancel];
}
//    1.  检测是不是系统信任的
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   
}
//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
//{
//    
//}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
   
}
@end
