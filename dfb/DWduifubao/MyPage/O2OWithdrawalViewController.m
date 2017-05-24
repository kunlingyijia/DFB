//
//  O2OWithdrawalViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OWithdrawalViewController.h"
#import "O2OModel.h"
@interface O2OWithdrawalViewController ()
@property(nonatomic,strong)UIView *keepOutView;
@end

@implementation O2OWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资道提现";
    [self showBackBtn];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.draw_moneylabel.text = [NSString stringWithFormat:@"%.2f",self.TiXianModel.draw_money];
    NSLog(@"%@",self.TiXianModel.channel_pay);

    //
    [self requestZDGeRenAction];
    [self addkeepOutView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //遮挡视图
    [self keepOutViewToBack];
    
}
#pragma mark - 遮挡视图
-(void)addkeepOutView{
    self.keepOutView = [[UIView alloc]initWithFrame:self.view.frame];
    _keepOutView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_keepOutView];
    
    [self keepOutViewToBack];
    
}
#pragma mark - 遮挡视图回归
-(void)keepOutViewToBack{
    [self.view sendSubviewToBack:_keepOutView];
}
#pragma mark - 遮挡视图推出
-(void)keepOutViewToFront{
    [self.view bringSubviewToFront:_keepOutView];
    
    
}

#pragma mark - 提现
- (IBAction)TiXianAction:(UIButton *)sender {
    
    if ([self.amountTF.text floatValue]>self.TiXianModel.draw_money ||self.amountTF.text.length==0) {
        [self showToast:@"请输入正确提现金额"];
        return;
    }
    [self keepOutViewToFront];
    [self requestAction];
  
}
-(void)requestAction{
    __weak typeof(self) weakSelf = self;
    NSString *Token =[AuthenticationModel getLoginToken];
    O2OModel * model = [[O2OModel alloc]init];
    model.amount = self.amountTF.text;
    model.channel_pay = self.TiXianModel.channel_pay;
    NSLog(@"%@",self.TiXianModel.channel_pay);
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/O2O/requestPayWithdraw" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            [self keepOutViewToBack];
            NSLog(@"提现----%@",response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                
            }else {
                [weakSelf showToast:response[@"msg"]];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
}

#pragma mark - 获取资道实名认证信息
-(void)requestZDGeRenAction{
    
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/O2O/requestZidaoCertificationInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
           // NSLog(@"%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
                weakSelf.bank_account_numberLabel.text = [NSString stringWithFormat:@"%@",            response[@"data"][@"bank_account_number"]];
          
            }else{
                [weakSelf showToast:response[@"msg"]];
                
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
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
