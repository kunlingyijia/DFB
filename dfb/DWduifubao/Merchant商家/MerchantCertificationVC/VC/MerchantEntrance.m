//
//  MerchantEntrance.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MerchantEntrance.h"
#import "MerchantIntroduceVC.h"
#import "MerchantCertificationModel.h"
@interface MerchantEntrance ()
@property (nonatomic,strong)MerchantCertificationModel *MCModel;
//1-添加 2-修改 (在拒绝时候选择修改)
@property(nonatomic,strong)NSString *edit_type;
@end

@implementation MerchantEntrance

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的店铺";
    self.MCModel = [[MerchantCertificationModel alloc]init];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    
}

- (IBAction)BackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)GoToAction:(UIButton *)sender {
    //Push 跳转
    MerchantIntroduceVC * VC = [[MerchantIntroduceVC alloc]initWithNibName:@"MerchantIntroduceVC" bundle:nil];
    self.MCModel.edit_type = @"1";

    VC.MCModel = self.MCModel;
    VC.edit_type = @"1";
    [self.navigationController  pushViewController:VC animated:YES];

    
    
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
