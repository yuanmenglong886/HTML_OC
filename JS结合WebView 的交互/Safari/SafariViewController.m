//
//  SafariViewController.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/9.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "SafariViewController.h"

@interface SafariViewController ()

@end

@implementation SafariViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.backgroundColor = [UIColor blueColor];
    [self.view addSubview:button];
    [button addTarget:self
               action:@selector(touchUp)
     forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint
    constraintWithItem:button
             attribute:NSLayoutAttributeLeft
             relatedBy:NSLayoutRelationEqual
                toItem:self.view
             attribute:NSLayoutAttributeLeft
            multiplier:1
              constant:50];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-50];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
    NSArray *array = @[leftConstraint,rightConstraint,topConstraint,bottomConstraint];
    [self.view addConstraints:array];
    
    // Do any additional setup after loading the view.
}
- (void)touchUp
{
 NSURL *url = [NSURL URLWithString:@"https://www.qiangui.58.com"];
 [[UIApplication sharedApplication] openURL:url];
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
