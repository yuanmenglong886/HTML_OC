//
//  QGJSBridge.h
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/8.
//  Copyright © 2017年 yml. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol QGJSBridgeDelegate<NSObject>
@optional

@end

@interface QGJSBridge : NSObject<WKScriptMessageHandler>
@property (nonatomic,weak) WKWebView *webView;
@property (nonatomic,weak) id<QGJSBridgeDelegate> delegate;
- (instancetype)initWithDelegate:(id<QGJSBridgeDelegate>)delegate  controller:(UIViewController *)viewcontroller;
@end
