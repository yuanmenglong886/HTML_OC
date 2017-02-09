//
//  QGJSBridge.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/8.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "QGJSBridge.h"

@interface QGJSBridge()
@property (nonatomic,weak) UIViewController *controller;
@end

@implementation QGJSBridge
- (instancetype)initWithDelegate:(id<QGJSBridgeDelegate>)delegate controller:(UIViewController *)viewcontroller
{
    if(self = [super init])
    {
       self.delegate = delegate;
       self.controller = viewcontroller;
    }
    return self;
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    NSLog(@"%@",message);
}

- (void)dealloc {
    NSLog(@"%@, %s", self.class, __func__);
}
@end
