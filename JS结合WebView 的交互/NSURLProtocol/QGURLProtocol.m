//
//  QGURLProtocol.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/9.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "QGURLProtocol.h"

@implementation QGURLProtocol
- (instancetype)init
{
    if(self = [super init])
    {
//        self.client = self;
    }
    return self;
}
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    BOOL intercept = YES;
    NSLog(@"%@",request.URL.absoluteString);
    if(intercept){
    
    }
    return intercept;
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
      return request;
}
- (void)stopLoading
{
     [super stopLoading];
}
- (void)startLoading
{

      [super startLoading];
}
@end
