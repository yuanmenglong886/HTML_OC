//
//  NativeViewController.m
//  JS结合WebView 的交互
//
//  Created by 58 on 17/2/10.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "NativeViewController.h"

@interface NativeViewController ()

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    titleLabel.text=@"原生页面";
    titleLabel.textColor=[UIColor redColor];
    [self.view addSubview:titleLabel];
    

    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];
    [backButton setBackgroundColor:[UIColor whiteColor]];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    // Do any additional setup after loading the view.
}
-(void)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
