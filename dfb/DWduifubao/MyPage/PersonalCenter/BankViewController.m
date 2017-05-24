//
//  BankViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//
#import "BankViewController.h"
#import "BankChangeViewController.h"
#import "PersonRenZhengModel.h"
@interface BankViewController ()
@property(nonatomic,strong)NSMutableDictionary* BackDic;
///认证拒绝传的Model
@property (nonatomic, strong) PersonRenZhengModel *perModel ;
@end
@implementation BankViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];

}
#pragma mark - 修改btn
- (IBAction)ChangeAction:(UIButton *)sender {
  //Push 跳转
  BankChangeViewController   * VC = [[BankChangeViewController alloc]initWithNibName:@"BankChangeViewController" bundle:nil];
    VC.perModel = self.perModel;
    [self.navigationController  pushViewController:VC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //网络请求
    [self requestAction];
}
#pragma mark - 网络请求
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Finance/requestBankInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                self.perModel= [PersonRenZhengModel yy_modelWithJSON:response[@"data"]];
                dic = response[@"data"];
                weakSelf.BackDic = response[@"data"];
                weakSelf.account_name.text = dic[@"account_name"];
                weakSelf.bank_account_number.text = dic[@"bank_account_number"];
                weakSelf.bank_nameAndsubbranch.text = [NSString stringWithFormat:@"%@ %@",dic[@"bank_name"],dic[@"subbranch"]];
                
            }else{
                [weakSelf showToast:response[@"msg"]];

            }
            NSLog(@"%@",response[@"data"]);
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
