//
//  PermissionViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PermissionViewController.h"

@interface PermissionViewController ()<UIWebViewDelegate>

@end
//权限说明
@implementation PermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = [NSString stringWithFormat:@"%@",[AuthenticationModel getauth_url]];
    //NSLog(@"%@",[AuthenticationModel geto2o_url]);
    self.webView.delegate = self;
    [self loadHTML:url];}

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