//
//  ViewController.m
//  JS结合WebView 的交互
//
//  Created by yml on 16/3/19.
//  Copyright © 2016年 yml. All rights reserved.
//

#import "ViewController.h"
#import "QGWKWebViewController.h"
#import "QGWebViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy)  NSMutableArray *controllerArray;
@end
/*
 test.html 村域服务器 ，里面的html和JS代码。。 我们是无法修改的
 如果texst.html 显示在手机端 ， 把哪个ul 去掉
 
 
 
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.controllerArray = [NSMutableArray arrayWithObjects:@"HrefViewController",@"IframeViewController",@"WebViewAndJSScriptCoreController",@"QGWKWebViewController",@"QGWebViewController",@"SafariViewController",@"SFViewController",nil];
    [self installTableView];
    

}
- (void)installTableView
{
     UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame];
     tableView.delegate = self;
     tableView.dataSource = self;
     [self.view addSubview:tableView];
     self.tableView = tableView;
     [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.controllerArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.controllerArray[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *class = self.controllerArray[indexPath.row];
     if([class isEqualToString:@"QGWKWebViewController"] )
     {
           [QGWKWebViewController qgWkWebViewControllerWithURL:@"https://www.baidu.com" target:self];
           return;
     }else if([class isEqualToString:@"QGWebViewController"])
     {
         
           [QGWebViewController qgWebViewControllerWithURL:@"https://www.baidu.com" target:self];
           return;
     }
    Class cls= NSClassFromString(self.controllerArray[indexPath.row]);
     [self.navigationController pushViewController:[[cls alloc]init] animated:YES];
}
@end
