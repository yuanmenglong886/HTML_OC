//
//  JSPatchAndHTMLController.h
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/10.
//  Copyright © 2017年 yml. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface JSPatchAndHTMLController : UIViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic,weak) WKWebView *wkWebView;
@property (nonatomic,strong)WKWebView *rwWebView;
@end
