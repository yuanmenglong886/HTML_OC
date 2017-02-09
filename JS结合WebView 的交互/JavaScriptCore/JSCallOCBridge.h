//
//  JSCallOCBridge.h
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/7.
//  Copyright © 2017年 yml. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSCallOCBridgeExport <JSExport>
- (void)protocolJSCallOCInWebView:(NSDictionary *)obj;
JSExportAs (CallNative,- (void) jsCallNative:(NSString *)jsParameter);
@end


@interface JSCallOCBridge : NSObject<JSCallOCBridgeExport>
{
      JSContext *context;
}
- (instancetype)initWithContext:(JSContext *)context;
@end
