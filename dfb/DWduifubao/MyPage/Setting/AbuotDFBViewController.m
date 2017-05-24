//
//  AbuotDFBViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AbuotDFBViewController.h"

@interface AbuotDFBViewController ()

@end

@implementation AbuotDFBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"关于兑富宝";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //代码实现获得应用的Verison号：
    NSString *oldVerison =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //获得build号：
    NSString *build =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    NSLog(@"build=====%@",build);
    self.Label.text =[NSString stringWithFormat: @"For iPhone V%@ bulid%@",oldVerison,build];

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
