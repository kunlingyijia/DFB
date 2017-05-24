//
//  UPNembersViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "UPNembersViewController.h"
#import "RealNameCertificationController.h"
#import "BuyNemberViewController.h"
@interface UPNembersViewController ()

@end

@implementation UPNembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"升级创业会员";
    [self.UpBtn setTitle:self.upBtnTitle forState:(UIControlStateNormal)];
}
- (IBAction)ShiMingRenZhengAction:(UIButton *)sender {
    
    //已经实名认证 (按钮改成立即升级)
     NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    if ([type isEqualToString:@"2"]) {
        NSLog(@"跳转到购买会员界面");
        BuyNemberViewController *BuyVC = [[BuyNemberViewController alloc]initWithNibName:@"BuyNemberViewController" bundle:nil];
        [self.navigationController pushViewController:BuyVC animated:YES];
        
    }else{
        //没有实名认证 (实名认证)
        RealNameCertificationController * vc = [[RealNameCertificationController alloc]initWithNibName:@"RealNameCertificationController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
