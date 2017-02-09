//
//  SFViewController.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/9.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "SFViewController.h"
#import <SafariServices/SafariServices.h>
@interface SFViewController ()

@end

@implementation SFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//        self.view.backgroundColor = [UIColor blueColor];
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    SFSafariViewController *sfViewController = [[SFSafariViewController alloc]initWithURL:url entersReaderIfAvailable:NO];
    sfViewController.preferredBarTintColor = [UIColor redColor];
    sfViewController.preferredControlTintColor = [UIColor blueColor];
    [self presentViewController:sfViewController animated:YES completion:nil];
            // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
