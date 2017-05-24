//
//  SucessRealNameCertificationController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SucessRealNameCertificationController.h"

@interface SucessRealNameCertificationController ()

@end

@implementation SucessRealNameCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showBackBtn];
     self.title =@"实名认证";
     [self.navigationController setNavigationBarHidden:NO animated:YES];
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
