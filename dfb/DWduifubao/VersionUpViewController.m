//
//  VersionUpViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "VersionUpViewController.h"

@interface VersionUpViewController ()<UIWebViewDelegate>

@end

@implementation VersionUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate =self;
    [self loadHTML:self.url];
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
