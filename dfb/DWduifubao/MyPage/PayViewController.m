//
//  PayViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PayViewController.h"
#import "SetPayPasswordController.h"
#import "RequestPayATOrderModel.h"
#import "MoneyViewController.h"
#import "MyPropertyViewController.h"
#import "BuyNemberViewController.h"

@interface PayViewController ()<JHCoverViewDelegate,UITextFieldDelegate>
@property(nonatomic,assign)BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;
@property (nonatomic, strong) JHCoverView *coverView;
//支付方式  支付宝1 微信2
@property(nonatomic,strong)NSString *pay_type;


@end

@implementation PayViewController
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
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.pay_type = @"1";
    self.MoneyTextfield.delegate = self;
    if ([self.title isEqualToString:@"现金充值"]) {
        
    }else if ([self.title isEqualToString:@"兑富金币充值"]){
        self.MoneyTextfield.placeholder = @"请输入充值兑富金币数量";
        
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.MoneyTextfield) {
        
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            _isHaveDian = NO;
        }
        if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
            _isFirstZero = NO;
        }
        
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                
                if([textField.text length]==0){
                    if(single == '.'){
                        //首字母不能为小数点
                        return NO;
                    }
                    if (single == '0') {
                        _isFirstZero = YES;
                        return YES;
                    }
                }
                
                if (single=='.'){
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian=YES;
                        return YES;
                    }else{
                        return NO;
                    }
                }else if(single=='0'){
                    if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if([textField.text isEqualToString:@"0.0"]){
                            return NO;
                        }
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=(int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if (_isFirstZero&&!_isHaveDian){
                        //首位有0没.不能再输入0
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    if (_isHaveDian){
                        //存在小数点，保留两位小数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt= (int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if(_isFirstZero&&!_isHaveDian){
                        //首位有0没点
                        return NO;
                    }else{
                        return YES;
                    }
                }
            }else{
                //输入的数据格式不正确
                return NO;
            }
        }else{
            return YES;
        }
    }
    return YES;
}
#pragma mark - 支付宝选择点击事件
- (IBAction)ZhiFuBaoAction:(UIButton *)sender {
    self.pay_type = @"1";
    [sender setImage:[UIImage imageNamed:@"我的-地址管理-选中"] forState:(UIControlStateNormal)];
    [self.WXBtn setImage:[UIImage imageNamed:@"我的-地址管理-未选中"] forState:(UIControlStateNormal)];

    
}
#pragma mark - 微信选择点击事件
- (IBAction)WXAction:(UIButton *)sender {
    self.pay_type = @"2";
    [sender setImage:[UIImage imageNamed:@"我的-地址管理-选中"] forState:(UIControlStateNormal)];
    [self.ZhiFuBaoBtn setImage:[UIImage imageNamed:@"我的-地址管理-未选中"] forState:(UIControlStateNormal)];

}


//确认提交
- (IBAction)BuyBtnAction:(UIButton *)
sender {
    
   
    if (self.MoneyTextfield.text.length==0) {
        [self showToast:@"请输入金额"];
        return;
    }
    if ([self.title isEqualToString:@"现金充值"]) {
        
        [self requestTopUp:Request_RechargeDfbao];
        
    }else if ([self.title isEqualToString:@"兑富金币充值"]){
        self.MoneyTextfield.placeholder = @"请输入充值金额";
        [self requestTopUp:Request_RechargeVirtualGlod];
    }

    
}

#pragma mark - 充值网络接口请求
-(void)requestTopUp:(NSString *)act{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"pay_amount":[NSString stringWithFormat:@"%@.00", _MoneyTextfield.text],@"pay_type":self.pay_type} yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:act sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"%@",response);
            
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                RequestPayATOrderModel *model = [RequestPayATOrderModel  yy_modelWithJSON:response[@"data"]];
                
                if ([self.pay_type isEqualToString:@"1"]) {
                    [weakSelf ZFBPayWithModel:model];
                    
                }else{
                    
                }
                
            }else{
                [weakSelf showToast:response[@"msg"]];
                
            }
        } faild:^(id error) {
        }];
        
    }
    
}

#pragma mark - 调取支付支付宝支付
-(void)ZFBPayWithModel:(RequestPayATOrderModel*)model{
    __weak typeof(self) weakSelf = self;

    [[AlipaySDK defaultService] payOrder:model.prealipay fromScheme:@"DFB" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString *resultStatus = resultDic[@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            //成功后界面跳转
            [weakSelf successPayBackToVC];

        }
    }];
    

}

//#pragma mark - 支付宝支付结果
//-(void)ZhiFuHuiDiao:(NSNotification*)sender{
//    
//    //成功后界面跳转
//    [self successPayBackToVC];
//  
//}
#pragma mark - 调取微信进行支付
-(void)WXPayWithModel:(RequestPayATOrderModel*)model{
    //调用微信支付
#warning 微信支付 ---有问题
   // [WXApi sendReq:model.prealipay];
}
#pragma mark - 微信支付结果
-(void)payBack:(NSNotification *)sender{
    PayResp *response = sender.object;
    switch(response.errCode){
        case WXSuccess:{
            //服务器端查询支付通知或查询API返回的结果再提示成功
            //成功后界面跳转
            [self successPayBackToVC];
            NSLog(@"支付成功");
        }
            break;
        case WXErrCodeAuthDeny:
            
            NSLog(@"授权失败");
            break;
        default:
            NSLog(@"支付失败，retcode=%d",response.errCode);
            break;
    }
    
}
#pragma mark - 支付成功界面跳转
-(void)successPayBackToVC{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MoneyViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];


        }else
        if ([temp isKindOfClass:[MyPropertyViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            
        }else
            if ([temp isKindOfClass:[BuyNemberViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                
            }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)dealloc{
   // [[NSNotificationCenter defaultCenter]removeObserver:self ];
    // [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:@"weixinPay"];
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
