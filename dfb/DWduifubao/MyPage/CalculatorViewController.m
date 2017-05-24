//
//  CalculatorViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalulatorBtn.h"
#import "O2OErWeiMaViewController.h"
#import "O2OModel.h"
#import "ZIDAOViewController.h"
#import "IQKeyboardManager.h"

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收款";
    [self showBackBtn];
    //将UITextField键盘设置为空 有光标 但是不弹出键盘 这一步很重要
    self.Textfield.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.Textfield becomeFirstResponder];
    self.OkBtn.backgroundColor = [UIColor redColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;

}
-(void)requestAction{
   // NSLog(@"%@",self.Textfield.text);
    if (self.Textfield.text.length==0) {
        [self showToast:@"金额不能为空"];
        return;
    }
    if ([self.Textfield.text doubleValue]<0.01) {
        //NSLog(@"%f",[self.Textfield.text doubleValue]);
        [self showToast:@"金额不能小于0.01"];
        return;
    }
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    O2OModel *model = [[O2OModel alloc]init];
    model.channel_pay = self.calculatorModel.channel_pay;
    model.channel_type = self.calculatorModel.channel_type;
    model.pay_name = self.calculatorModel.pay_name;
    model.pay_title = self.calculatorModel.pay_title;

    NSLog(@"支付通道%@",model.channel_pay);
    NSLog(@"渠道类型%@",model.channel_type);
    model.amount = self.Textfield.text;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
            __weak typeof(self) weakSelf = self;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_PayOrder sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"------%@",response);
            if (baseRes.resultCode == 1) {
//                is_notice				是否弹小窗提示0-否 1-是
//                notice_msg				提示内容
                NSDictionary * dic =response[@"data"];
                NSString * is_notice  =[NSString stringWithFormat:@"%@", dic[@"is_notice"]];
                if ( [is_notice isEqualToString:@"1"] ) {
                    
                    [weakSelf alertWithTitle:@"温馨提示" message:dic[@"notice_msg"] OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
                        /*------资道---------*/
                        if ([model.channel_type isEqualToString:@"2"]&&[model.channel_pay isEqualToString:@"1"]) {
                            //资道银行卡
                            //Push跳转
                            ZIDAOViewController * VC = [[ZIDAOViewController alloc]init];
                            if ([response[@"data"][@"zidao_url"] isKindOfClass:[NSNull class]]) {
                                weakSelf.view.userInteractionEnabled = YES;
                                return ;
                            }
                            VC.url =response[@"data"][@"zidao_url"];
                            [weakSelf.navigationController  pushViewController:VC animated:YES];
                        }
                        if ([model.channel_type isEqualToString:@"1"]) {
                            O2OErWeiMaViewController * VC = [[O2OErWeiMaViewController alloc]initWithNibName:@"O2OErWeiMaViewController" bundle:nil];
                            VC.qrcode_url =response[@"data"][@"qrcode_url"];
                            VC.ErWeiMaLabelStr = model.pay_title;
                            [weakSelf.navigationController  pushViewController:VC animated:YES];
                        }
                    }];
                }else{
                /*------资道---------*/
                if ([model.channel_type isEqualToString:@"2"]&&[model.channel_pay isEqualToString:@"1"]) {
                    //资道银行卡
                    //Push跳转
                    ZIDAOViewController * VC = [[ZIDAOViewController alloc]init];
                    if ([response[@"data"][@"zidao_url"] isKindOfClass:[NSNull class]]) {
                        weakSelf.view.userInteractionEnabled = YES;
                        return ;
                    }
                    VC.url =response[@"data"][@"zidao_url"];
                    [weakSelf.navigationController  pushViewController:VC animated:YES];
                }
                
                
                if ([model.channel_type isEqualToString:@"1"]) {
                    O2OErWeiMaViewController * VC = [[O2OErWeiMaViewController alloc]initWithNibName:@"O2OErWeiMaViewController" bundle:nil];
                    VC.qrcode_url =response[@"data"][@"qrcode_url"];
                    VC.ErWeiMaLabelStr = model.pay_title;
                    [weakSelf.navigationController  pushViewController:VC animated:YES];
                }
                    
                }
//                 /*------华付通---------*/
//                if ([model.channel_type isEqualToString:@"1"]&&[model.channel_pay isEqualToString:@"2"]) {
//                    //华付通微信
//                    //Push 跳转
//                    O2OErWeiMaViewController * VC = [[O2OErWeiMaViewController alloc]initWithNibName:@"O2OErWeiMaViewController" bundle:nil];
//                    VC.qrcode_url =response[@"data"][@"qrcode_url"];
//                    VC.ErWeiMaLabelStr = @"微信";
//                    [weakSelf.navigationController  pushViewController:VC animated:YES];
//                }
//                if ([model.channel_type isEqualToString:@"1"]&&[model.channel_pay isEqualToString:@"3"]) {
//                    //华付通支付宝
//                    O2OErWeiMaViewController * VC = [[O2OErWeiMaViewController alloc]initWithNibName:@"O2OErWeiMaViewController" bundle:nil];
//                    VC.qrcode_url =response[@"data"][@"qrcode_url"];
//                    VC.ErWeiMaLabelStr = @"支付宝";
//                    [weakSelf.navigationController  pushViewController:VC animated:YES];
//                }
//                
//                if ([model.channel_type isEqualToString:@"1"]&&[model.channel_pay isEqualToString:@"5"]) {
//                    //华付通支付宝
//                    O2OErWeiMaViewController * VC = [[O2OErWeiMaViewController alloc]initWithNibName:@"O2OErWeiMaViewController" bundle:nil];
//                    VC.qrcode_url =response[@"data"][@"qrcode_url"];
//                    VC.ErWeiMaLabelStr = @"QQ";
//                    [weakSelf.navigationController  pushViewController:VC animated:YES];
//                }
            
            
            }else if(baseRes.resultCode == 2005) {
                    [weakSelf showToast:response[@"data"]];
                    weakSelf.view.userInteractionEnabled = YES;
                    
                }else{
                    [weakSelf showToast:response[@"msg"]];
                    weakSelf.view.userInteractionEnabled = YES;
                }

  
        } faild:^(id error) {
        weakSelf.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }
}

- (IBAction)BtnAction:(CalulatorBtn *)sender {
    [self.Textfield becomeFirstResponder];
    // 数字
    // 含有小数点
    if([self.Textfield.text containsString:@"."]){
        NSRange ran = [self.Textfield.text rangeOfString:@"."];
        if (self.Textfield.text.length<9) {
        if (self.Textfield.text.length - ran.location <= 2) {
            NSString *text = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
            [self.Textfield insertText:text];
           }
       }
    }else{
        if (self.Textfield.text.length<6) {
            NSString *text = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
            [self.Textfield insertText:text];
        }
        
    }

}
- (IBAction)pointBtn:(CalulatorBtn *)sender {
    [self.Textfield becomeFirstResponder];
    // 小数点
    if(self.Textfield.text.length > 0 && ![self.Textfield.text containsString:@"."]){
        [self.Textfield insertText:@"."];
    }

}
- (IBAction)deletebtn:(CalulatorBtn *)sender {
    [self.Textfield becomeFirstResponder];
    // 删除
    if(self.Textfield.text.length > 0){
        [self.Textfield deleteBackward];
    }
}

//取消
- (IBAction)CancelAction:(CalulatorBtn *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)OKAction:(CalulatorBtn *)sender {
    //网络请求
    [self requestAction];    
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
