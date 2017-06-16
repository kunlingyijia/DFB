//
//  UpdatePhoneController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "UpdatePhoneController.h"
#import "RequestRegister.h"
#import "RequestVerifyCode.h"
#import "LoginController.h"
@interface UpdatePhoneController ()

@end

@implementation UpdatePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"修改手机号";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.nowPhone.text = [NSString stringWithFormat:@"更换手机后，下次登录可使用新手机号登录。当前手机号：%@",[AuthenticationModel getPhoneNumber]];
    
}

//"获取验证码"的按钮事件
- (IBAction)getVerificationCodeBtnAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    if ([self.resetPhone.text isPhoneNumber]) {
        UIButton *btn = sender;
        btn.backgroundColor = [UIColor whiteColor];
        btn.userInteractionEnabled = NO;
        //    self.authCode.userInteractionEnabled = YES;
        //    self.promptLabel.text = @"接受短信大约需要60秒";
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
        verifyCode.mobile = self.resetPhone.text;
        verifyCode.type = 3;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.data = [verifyCode yy_modelToJSONObject];
        baseReq.encryptionType = RequestMD5;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Code sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                 [weakSelf showToast:@"获取验证码成功"];
                NSLog(@"获取验证码成功%@", response);
              

            }
            else if ([response[@"resultCode"] isEqualToString:@"11"]) {
                NSLog(@"获取验证码成功%@", response);

                [weakSelf showToast:@"该手机号已注册"];

            }else{
                [weakSelf showToast:response[@"msg"]];

            }
           
            
            
        } faild:^(id error) {
            
        }];

    }

    
    
}

//"更换"的按钮事件
- (IBAction)updateBtnAction:(id)sender {

    NSString *Token =[AuthenticationModel getLoginToken];
    RequestRegister * model = [[RequestRegister alloc ]init ];
//    model.mobile = self.resetPhone.text
//    ;
//    model.verify_code = self.verificationCode.text;
    //NSLog(@"验证码%@",self.resetPhone.text);
    NSDictionary * dic = @{@"mobile":self.resetPhone.text,@"verify_code":@([self.verificationCode.text intValue])};
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
         baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
       // baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];

        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestChangePhone" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"-----%@",response);    //[weakself showToast:@"修改成功"];
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
               // [weakself showToast:@"更新成功"];
                [AuthenticationModel moveLoginKey];
                [AuthenticationModel moveLoginToken];
                [AuthenticationModel moveindiana_moblie];
                [AuthenticationModel moveCarNumber];
                [weakself.navigationController popViewControllerAnimated:YES];
            }else{
                [weakself showToast:response[@"msg"]];

            }
            
            
            
            
        } faild:^(id error) {
            NSLog(@"错误%@", error);
            
        }];
        
    }
//    else {
//        [weakself showToast:@"请登录后修改"];
//        //[weakself.navigationController popViewControllerAnimated:YES];
//    }
}
@end
