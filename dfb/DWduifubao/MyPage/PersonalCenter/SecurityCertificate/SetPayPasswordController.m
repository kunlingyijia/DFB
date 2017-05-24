//
//  SetPayPasswordController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SetPayPasswordController.h"
#import "RequestVerifyCode.h"
#import "RequestRegister.h"
@interface SetPayPasswordController ()

@end

@implementation SetPayPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    //self.title = @"设置支付密码";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.phone.text = [AuthenticationModel getPhoneNumber];
    NSLog(@"设置支付密码%@", [AuthenticationModel getPhoneNumber]);
}

//"获取验证码"的按钮事件
- (IBAction)getVerificationCodeBtnAction:(id)sender {
    
    if ([self.phone.text isPhoneNumber]) {
        UIButton *btn = sender;
        btn.backgroundColor = [UIColor whiteColor];
        btn.userInteractionEnabled = NO;
        
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                //倒计时结束 改变颜色
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    btn.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 120;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [btn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    btn.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        RequestVerifyCode *verifyCode = [[RequestVerifyCode alloc] init];
        verifyCode.mobile = self.phone.text;
        //verifyCode.mobile  = @"18317894322";
        verifyCode.type = 4;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.data = [verifyCode yy_modelToJSONObject];
        baseReq.encryptionType = RequestMD5;
        __weak typeof(self) weakSelf = self;

        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Code sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [weakSelf showToast:@"获取验证码成功"];
                NSLog(@"获取验证码成功%@", response);
                
            }else{
                [weakSelf showToast:response[@"msg"]];

            }
            
            
            
        } faild:^(id error) {
            
        }];
        
    }
    

}

//"确定"的按钮事件
- (IBAction)confirmBtnAction:(id)sender {
    
    if (self.setPayPassword.text.length!= 6) {
        [self showToast:@"密码为6位数"];
        return;
    }
    if (self.verificationCode.text.length == 0) {
        [self showToast:@"请填写验证码"];
        return;
        
    }
    NSString *Token =[AuthenticationModel getLoginToken];
    RequestRegister * model = [[RequestRegister alloc ]init ];
    model.pay_password = self.setPayPassword.text
    ;
    model.verify_code = self.verificationCode.text;
    NSLog(@"支付密码%@",model.password);
    
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        
        baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_SetPayPassword sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            
            NSLog(@"-----%@",response[@"msg"]);    //[weakself showToast:@"修改成功"];
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isset_paypwd"];
                 [self.navigationController popViewControllerAnimated:YES];
                //[self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [weakself showToast:response[@"msg"]];
            }
           
            
        } faild:^(id error) {
            NSLog(@"%@", error);
            
        }];
        
    }else {
        [weakself showToast:@"请登录后修改"];
        //[weakself.navigationController popViewControllerAnimated:YES];
    }

    
    
    
}
@end
