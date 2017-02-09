//
//  JSCallOCBridge.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/7.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "JSCallOCBridge.h"

@implementation JSCallOCBridge

- (void)jsCallNative:(NSString *)jsParameter
{
    JSValue *currentThis = [JSContext currentThis];
    JSValue *currentCallee = [JSContext currentCallee];
    NSArray *currentParamers = [JSContext currentArguments];
    dispatch_async(dispatch_get_main_queue(), ^{
        /**
         *  js调起OC代码，代码在子线程，更新OC中的UI，需要回到主线程
         */
    });
    NSLog(@"JS paramer is %@",jsParameter);
    NSLog(@"currentThis is %@",[currentThis toString]);
    NSLog(@"currentCallee is %@",[currentCallee toString]);
    NSLog(@"currentParamers is %@",currentParamers);
}
- (instancetype)initWithContext:(JSContext *)context
{
    if(self = [super init])
    {
         self->context = context;
       // context[@"JSCallOCBridge"] = self;
    }
    return self;
}
- (void)protocolJSCallOCInWebView:(NSDictionary *)obj
{
        NSArray *currentParamers = [JSContext currentArguments];
        NSLog(@"%@",[[currentParamers firstObject] toDictionary]);
        NSLog(@"obj:%@",obj);
}
@end
