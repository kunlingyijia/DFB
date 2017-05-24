//
//  MerchantIntroduceVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MerchantIntroduceVC.h"
#import "IndustryClassOneVC.h"
#import "MerchantDataOneVC.h"
#import "MerchantCertificationModel.h"

@interface MerchantIntroduceVC ()

@end

@implementation MerchantIntroduceVC
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
     self.MCModel.merchant_name = self.merchant_name.text;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self kongjianfuzhi];
    NSLog(@"%@",[self.MCModel yy_modelToJSONObject]);
}
-(void)kongjianfuzhi{
    self.merchant_name.text = self.MCModel.merchant_name;
    [self.industry_name setTitle:self.MCModel.industry_name.length==0 ?@"请选择经营品类":self.MCModel.industry_name forState:(UIControlStateNormal)];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(IndustryData:) name:@"行业类型" object:nil];
    
}
-(void)IndustryData:(NSNotification*)sender{
    NSDictionary * Mdic = sender.userInfo;
    NSDictionary *IndustryDic = Mdic[@"行业类型"];
    [self.industry_name setTitle:IndustryDic[@"name"] forState:(UIControlStateNormal)];
    self.MCModel.industry_name=IndustryDic[@"name"];
    self.MCModel.industry_id =IndustryDic[@"industry_id"];
    
    
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"店铺介绍";
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
   
    
}

- (IBAction)ChooseKindBtnAction:(UIButton *)sender {
    
    //Push 跳转
    IndustryClassOneVC * VC = [[IndustryClassOneVC alloc]initWithNibName:@"IndustryClassOneVC" bundle:nil];
    
    [self.navigationController  pushViewController:VC animated:YES];

    
    
}


- (IBAction)GoToShopAction:(UIButton *)sender {
    if ([self IF]) {
        //Push 跳转
        MerchantDataOneVC * VC = [[MerchantDataOneVC alloc]initWithNibName:@"MerchantDataOneVC" bundle:nil];
        VC.MCModel = self.MCModel;
        VC.edit_type = self.edit_type;
        [self.navigationController  pushViewController:VC animated:YES];
    }

    

    
}
#pragma mark - 判断条件
-(BOOL)IF{
    BOOL  Y = YES;
    self.MCModel.merchant_name = self.merchant_name.text;
    if (self.MCModel.merchant_name.length==0) {
        [self showToast:@"请输入店铺名称"];
        return NO;
    }
    if (self.MCModel.industry_id.length==0) {
        [self showToast:@"请选择行业类型"];
        return NO;
    }
    return Y;
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
