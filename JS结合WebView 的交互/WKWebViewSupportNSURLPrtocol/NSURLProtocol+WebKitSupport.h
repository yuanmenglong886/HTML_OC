//
//  NSURLProtocol+WebKitSupport.h
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/9.
//  Copyright © 2017年 yml. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (WebKitSupport)
+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;
@end
