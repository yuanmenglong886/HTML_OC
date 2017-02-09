//
//  QGWebViewController.h
//  Tool
//
//  Created by 58 on 16/7/19.
//  Copyright © 2016年 yuanmenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QGWebViewController : UIViewController
+ (QGWebViewController *)qgWebViewControllerWithURL:(NSString *)requestURL target:(UIViewController *)targetController;
@property (nonatomic,weak) UIWebView *webView;
@property (nonatomic,copy) NSString *requestUrl;

@end
