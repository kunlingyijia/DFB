//
//  SupplyShimingController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/2.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SupplyShimingController.h"
#import "PerfectDataController.h"
#import "RealNameCertificationController.h"
@interface SupplyShimingController ()

@end

@implementation SupplyShimingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要供货";
    [self showBackBtn];
   // 1. 配值数据源对象
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    

    [self.UPBtn setTitle:self.upBtnTitle forState:(UIControlStateNormal)];
}
#pragma mark - 跳转btn
- (IBAction)renZhengAction:(UIButton *)sender {
    if ([self.upBtnTitle isEqualToString:@"实名认证"]) {
        //没有实名认证 (实名认证)
        RealNameCertificationController * vc = [[RealNameCertificationController alloc]initWithNibName:@"RealNameCertificationController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.upBtnTitle isEqualToString:@"完善资料"]){
                PerfectDataController * VC = [[PerfectDataController alloc]initWithNibName:@"PerfectDataController" bundle:nil];
           //添加
               VC.type = @"1";
                [self.navigationController  pushViewController:VC animated:YES];
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
