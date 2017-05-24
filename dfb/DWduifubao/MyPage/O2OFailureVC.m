//
//  O2OFailureVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/16.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OFailureVC.h"
#import "O2ORealNameVC.h"
#import "PersonRenZhengModel.h"
@interface O2OFailureVC ()
@property (nonatomic, strong) PersonRenZhengModel *perModel ;

@end

@implementation O2OFailureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"实名认证(资道)";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.label.text = [NSString stringWithFormat:@"错误信息:%@", self.sh_msg];
    [self requestAction];
    
}
-(void)requestAction{
    
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/O2O/requestZidaoCertificationInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                weakSelf.perModel = [PersonRenZhengModel yy_modelWithJSON:response[@"data"]];
                
                
            }else{
                [weakSelf showToast:response[@"msg"]];
                
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}
//重新提交
- (IBAction)BtnAction:(UIButton *)sender {
    
    //Push 跳转
    O2ORealNameVC * VC = [[O2ORealNameVC alloc]initWithNibName:@"O2ORealNameVC" bundle:nil];
    VC.perModel = self.perModel;
    VC.pushTypeOfO2O = self.pushTypeOfO2O;
    [self.navigationController  pushViewController:VC animated:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
