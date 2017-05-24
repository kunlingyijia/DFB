//
//  GestureFindPasswordViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GestureFindPasswordViewController.h"
#import "RequestVerifyCode.h"
#import "RequestFindPassword.h"
#import "GestureSettingViewController.h"
@interface GestureFindPasswordViewController ()

@end

@implementation GestureFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   if ([self.pushSource isEqualToString:@"窗口"]) {
    self.navigationController.navigationBar.translucent = NO;
    }else{
        [self showBackBtn];
    }
    self.title = @"重置手势密码";
    self.userName.text = [AuthenticationModel getPhoneNumber];
}

#pragma mark - "获取验证码"的事件
- (IBAction)getVerificationCodeBtnAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    if ([self.userName.text isPhoneNumber]) {
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
        verifyCode.mobile = self.userName.text;
        verifyCode.type = 5;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.data = [verifyCode yy_modelToJSONObject];
        baseReq.encryptionType = RequestMD5;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Code sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [weakSelf showToast:@"获取验证码成功"];
            }else {
                [weakSelf showToast:response[@"msg"]];
            }
        } faild:^(id error) {
            
        }];
    }
}

#pragma mark - "确定"的事件
- (IBAction)findPasswordBtnAction:(id)sender {
    if (self.userName.text.length==0) {
        [self showToast:@"请输入手机号"];
        return;
    }
    if (self.verificationCode.text.length ==0) {
         [self showToast:@"请输入验证码"];
        return;
    }
    self.view.userInteractionEnabled = NO;
    RequestFindPassword *findPassword = [[RequestFindPassword alloc] init];
    findPassword.mobile = self.userName.text;
    findPassword.verify_code = self.verificationCode.text;
    findPassword.type = @"5";
    __weak typeof(self) weakSelf = self;
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[findPassword yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/VerifyCode/requestCheckVerifyCode" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                //Push 跳转
        GestureSettingViewController * VC = [[GestureSettingViewController alloc]initWithNibName:@"GestureSettingViewController" bundle:nil];
                [weakSelf.navigationController  pushViewController:VC animated:YES];
            }else {
                
                weakSelf.view.userInteractionEnabled = YES;
                [weakSelf showToast:response[@"msg"]];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
            weakSelf.view.userInteractionEnabled = YES;
        }];
        
    }
}

@end
