//
//  QGWKWebViewController.h
//  Tool
//
//  Created by 58 on 16/7/21.
//  Copyright © 2016年 yuanmenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface QGWKWebViewController : UIViewController
+ (QGWKWebViewController *)qgWkWebViewControllerWithURL:(NSString *)requestURL target:(UIViewController *)targetController;

@property (nonatomic,weak) WKWebView *webView;
@property (nonatomic,copy) NSString *requestUrl;
@end
