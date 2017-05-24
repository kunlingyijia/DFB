//
//  SecurityCertificateController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SecurityCertificateController.h"
#import "FindPasswordController.h"
#import "UpdatePhoneController.h"
#import "SetPayPasswordController.h"
#import "BankNewChangeViewController.h"
#import "AuditViewController.h"
#import "FailureViewController.h"
#import "UPNembersViewController.h"
#import "LoginController.h"
#import "GestureFindPasswordViewController.h"
#import "GestureVerificationViewController.h"
#import "GestureSettingViewController.h"
typedef void(^PushOhter)();

@interface SecurityCertificateController ()

@end

@implementation SecurityCertificateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showBackBtn];
    self.title = @"安全验证中心";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    [self addtargetAction];
    NSString * originTel = [AuthenticationModel getPhoneNumber];
    NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.phone.text = tel;
}

//为View添加点击事件
- (void)addtargetAction {
    //"登录密码"
    UITapGestureRecognizer *loginPasswordViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginPasswordViewAction:)];
    [self.loginPasswordView addGestureRecognizer:loginPasswordViewTap];
    //"手机验证"
    UITapGestureRecognizer *phoneVerificationViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneVerificationViewAction:)];
    [self.phoneVerificationView addGestureRecognizer:phoneVerificationViewTap];
    //"设置支付密码"
    UITapGestureRecognizer *setPayPasswordViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPayPasswordViewAction:)];
    [self.setPayPasswordView addGestureRecognizer:setPayPasswordViewTap];
}

//"登录密码"的View事件
- (void)loginPasswordViewAction:(UITapGestureRecognizer *)sender {
    FindPasswordController *findPasswordController = [[FindPasswordController alloc] initWithNibName:@"FindPasswordController" bundle:nil];
    [self.navigationController pushViewController:findPasswordController animated:YES];
}

//"手机验证"的View事件
- (void)phoneVerificationViewAction:(UITapGestureRecognizer *)sender {
    UpdatePhoneController *updatePhoneController = [[UpdatePhoneController alloc] initWithNibName:@"UpdatePhoneController" bundle:nil];
    [self.navigationController pushViewController:updatePhoneController animated:YES];
}

//"设置支付密码"的View事件
- (void)setPayPasswordViewAction:(UITapGestureRecognizer *)sender {
    SetPayPasswordController *setPayPasswordController = [[SetPayPasswordController alloc] initWithNibName:@"SetPayPasswordController" bundle:nil];
    setPayPasswordController.title = @"设置支付密码";
    setPayPasswordController.act = Request_SetPayPassword;
    [self.navigationController pushViewController:setPayPasswordController animated:YES];
}
#pragma mark - 修改银行卡
- (IBAction)ChangeBankAct:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self Realname:^{
        //Push 跳转
        BankNewChangeViewController * VC = [[BankNewChangeViewController alloc]initWithNibName:@"BankNewChangeViewController" bundle:nil];
        [weakSelf.navigationController  pushViewController:VC animated:YES];
        

    }];
    
}
#pragma mark - 找回手势密码
- (IBAction)FindShouShiPasswordAction:(UIButton *)sender {
    NSString * is_handle_password = [NSString stringWithFormat:@"%@",[AuthenticationModel getis_handle_password]];
    if ([is_handle_password  isEqualToString:@"0"]) {
        //Push 跳转
        GestureSettingViewController * VC = [[GestureSettingViewController alloc]initWithNibName:@"GestureSettingViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
 
    }else{
        //Push 跳转
        GestureVerificationViewController * VC = [[GestureVerificationViewController alloc]initWithNibName:@"GestureSettingViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
    }
    
    
}
#pragma mark - 忘记手势密码
- (IBAction)forgetShoushiPassword:(UIButton *)sender {
    //Push 跳转
    GestureFindPasswordViewController * VC = [[GestureFindPasswordViewController alloc]initWithNibName:@"GestureFindPasswordViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

}




#pragma mark - 实名认证公用
-(void)Realname:(PushOhter)pushOhter{
    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    NSString *Token =[AuthenticationModel getLoginToken]
    ;
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        //Push 跳转
        if ([type isEqualToString:@"2"]) {
            NSLog(@"认证成功");
            pushOhter();
            
        }  else if ([type  isEqualToString:@"1"]){
            NSLog(@"认证审核中");
            AuditViewController * adVC = [[AuditViewController alloc]initWithNibName:@"AuditViewController" bundle:nil];
            adVC.titleStr =@"实名认证";
            [self.navigationController pushViewController:adVC animated:YES];
        }else if( [type  isEqualToString:@"3"]){
            NSLog(@"认证失败");
            FailureViewController * adVC = [[FailureViewController alloc]initWithNibName:@"FailureViewController" bundle:nil];
            [self.navigationController pushViewController:adVC animated:YES];
            
        }else{
            NSLog(@"未认证");
            UPNembersViewController * VC = [[UPNembersViewController alloc]initWithNibName:@"UPNembersViewController" bundle:nil];
            VC.upBtnTitle =  @"实名认证";
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else{
        //Push 跳转
        LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
        [VC LoginRefreshAction:^{
            
        }];
        [weakSelf.navigationController  pushViewController:VC animated:YES];    }
    
    
    
    
    
}

@end
