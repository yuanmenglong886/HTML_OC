//
//  JSPatchAndHTMLController.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/10.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "JSPatchAndHTMLController.h"
#import "JPEngine.h"
#import <objc/runtime.h>
#import "NativeViewController.h"
@interface JSPatchAndHTMLController ()

@end

@implementation JSPatchAndHTMLController
//
//  ViewController.m
//  WKWebView-JSPatch
//
//  Created by BoWang on 16/4/12.
//  Copyright © 2016年 BoWang. All rights reserved.
//


- (void)viewDidLoad {
    [super viewDidLoad];
    [JPEngine startEngine];
    self.view.backgroundColor=[UIColor whiteColor];
    _rwWebView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_rwWebView.configuration.userContentController addScriptMessageHandler:self name:@"loadJavaScript"];
    [_rwWebView.configuration.userContentController addScriptMessageHandler:self name:@"RunOCFunction"];
    _rwWebView.backgroundColor = [UIColor clearColor];
    _rwWebView.scrollView.backgroundColor = [UIColor clearColor];
    _rwWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _rwWebView.scrollView.showsVerticalScrollIndicator=NO;
    _rwWebView.scrollView.showsHorizontalScrollIndicator=NO;
    _rwWebView.navigationDelegate = self;
    _rwWebView.allowsBackForwardNavigationGestures=YES;
    [self.view addSubview:_rwWebView];
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"JSPatch_OC" withExtension:@"html"];
    NSMutableURLRequest *tmpRequest=[[NSMutableURLRequest alloc] initWithURL:url];
    tmpRequest.timeoutInterval=60;
    [_rwWebView loadRequest:tmpRequest];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"loadJavaScript"]) {
        NSString *script=message.body;
        [JPEngine evaluateScript:script];
        NSLog(@"Script loaded");
    }
    else if ([message.name isEqualToString:@"RunOCFunction"])
    {
    //   获得OC运行时的所有方法
           unsigned int count;
      Method  *method  = class_copyMethodList([self class], &count);
     for(int i = 0; i < count; i++)
     {
            Method me = method[i];
            const char *name = method_getTypeEncoding(me);
            SEL  sel = method_getName(me);
            NSLog(@"%@",NSStringFromSelector(sel));
    }
    
        NSDictionary *messageDic=message.body;
        NSString *function=messageDic[@"function"];
        NSDictionary *parameters=messageDic[@"parameters"];
        if ([self respondsToSelector:NSSelectorFromString(function)]) {
            [self performSelectorOnMainThread:NSSelectorFromString(function) withObject:parameters waitUntilDone:YES];
            NSLog(@"Script excuted");

        }
        else NSLog(@"Please load script first");
    }
    
}


//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    WKWebViewConfiguration *wkConfig = [[WKWebViewConfiguration alloc]init];
//     wkConfig.userContentController = [[WKUserContentController alloc]init];
//
//        [wkConfig.userContentController addScriptMessageHandler:self name:@"LoadScript"];
//        [wkConfig.userContentController addScriptMessageHandler:self name:@"DoFunction"];
//    
//    WKWebView *wkWebView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:wkConfig];
//    [self.view addSubview:wkWebView];
//    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    wkWebView.allowsBackForwardNavigationGestures = YES;
//    wkWebView.backgroundColor = [UIColor whiteColor];
//    wkWebView.scrollView.showsVerticalScrollIndicator = NO;
//    wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
//    wkWebView.navigationDelegate = self;
//    
//    NSURL *urlPath = [[NSBundle mainBundle] URLForResource:@"JSPatch_OC" withExtension:@"html"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlPath];
//    [wkWebView loadRequest:request];
//    
//    
//    // Do any additional setup after loading the view.
//}
//#pragma mark - MessageHandler
//- (void)userContentController:(WKUserContentController *)userContentController
//      didReceiveScriptMessage:(WKScriptMessage *)message{
//    if ([message.name isEqualToString:@"LoadScript"]) {
//        NSString *script=message.body;
//        [JPEngine evaluateScript:script];
//        NSLog(@"Script loaded");
//    }
//    else if ([message.name isEqualToString:@"DoFunction"])
//    {
////      [self presentViewController:[[SecondViewController alloc]init] animated:YES completion:nil];
//        NSDictionary *messageDic=message.body;
//        NSString *function=messageDic[@"function"];
//        NSDictionary *parameters=messageDic[@"parameters"];
//        if ([self respondsToSelector:NSSelectorFromString(function)]) {
//            [self performSelectorOnMainThread:NSSelectorFromString(function) withObject:parameters waitUntilDone:YES];
//            NSLog(@"Script excuted");
//
//        }
//        else NSLog(@"Please load script first");
//    }
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
