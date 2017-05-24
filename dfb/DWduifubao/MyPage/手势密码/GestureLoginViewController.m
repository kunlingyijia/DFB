//
//  GestureLoginViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GestureLoginViewController.h"
#import "RegisterController.h"
#import "FindPasswordController.h"
#import "RequestLogin.h"
#import "MyPageController.h"
#import "AppDelegate.h"
#import "GestureSettingViewController.h"
@interface GestureLoginViewController ()<UITabBarControllerDelegate>


@end

@implementation GestureLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self showBackBtn];
    self.title = @"兑富宝登录";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    NSString *moblie = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_moblie"];
    self.userName.text = moblie;
    
}
#pragma mark - 登录事件
- (IBAction)loginBtnClick:(id)sender {
    if (self.userName.text.length==0) {
        [self showToast:@"请输入用户名"];
        return;
    }
    

//    if (![YanZhengOBject IsPassword:self.password.text]) {
//        [self showToast:@"密码为6-16(字母,数字)"];
//        return;
//    }
    
//    if (self.password.text.length==0) {
//        [self showToast:@"请输入密码"];
//        return;
//    }
    
    if (self.password.text.length <6||self.password.text.length >16) {
        [self showToast:@"密码为6-16(字母,数字,下划线)"];
        return;
    }
    
     //[self showProgress];
    self.view.userInteractionEnabled = NO;
    RequestLogin *login = [[RequestLogin alloc] init];
    login.mobile = self.userName.text;
    login.password = self.password.text;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = login;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Login sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            NSDictionary *dic = baseRes.data;
            NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
            [userDefau setObject:dic[@"key"] forKey:@"loginKey"];
            [userDefau setObject:dic[@"token"] forKey:@"loginToken"];
            [userDefau setObject:login.mobile forKey:@"user_moblie"];
            [userDefau setObject:login.password forKey:@"user_password"];
            //请求配置信息网络请求
            [BackgroundService PeizhiPushVC:nil RequestAction:^{
                
            }];
            //请求个人信息
            // [self requestMyselfAction];
            [BackgroundService requestPushVC:self MyselfAction:^{
                NSString * is_handle_password = [NSString stringWithFormat:@"%@",[AuthenticationModel getis_handle_password]];
                
                if ([is_handle_password  isEqualToString:@"0"]) {
                    //Push 跳转
                    GestureSettingViewController * VC = [[GestureSettingViewController alloc]initWithNibName:@"GestureSettingViewController" bundle:nil];
                    [weakself.navigationController  pushViewController:VC animated:YES];
                    
                }else{
                    
                    DWTabBarController* tabbar = [[DWTabBarController alloc]init];
                    [tabbar setSelectedIndex:3];
                    [weakself presentViewController:tabbar animated:NO completion:NULL];

                    
                }
            }];

//            //请求配置信息网络请求
//            [BackgroundService PeizhiRequestAction:^{
//                DWTabBarController* tabbar = [[DWTabBarController alloc]init];
//                [tabbar setSelectedIndex:3];
//                [weakself presentViewController:tabbar animated:NO completion:NULL];
//            }];
//            //请求个人信息
////            [self requestMyselfAction];
//            [BackgroundService requestMyselfAction:^{
//                
//            }];
            
        }else {
            [weakself showToast:response[@"msg"]];
            weakself.view.userInteractionEnabled = YES;
            
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
        weakself.view.userInteractionEnabled = YES;
        
    }];
    
}

//注册事件
- (IBAction)registerBtnClick:(id)sender {
    RegisterController *registerController = [[RegisterController alloc] initWithNibName:@"RegisterController" bundle:nil];
    [self.navigationController pushViewController:registerController animated:YES];
}

//找回密码事件
- (IBAction)findPasswordBtnClick:(id)sender {
    FindPasswordController *findPasswordController = [[FindPasswordController alloc] initWithNibName:@"FindPasswordController" bundle:nil];
    [self.navigationController pushViewController:findPasswordController animated:YES];
}

//眼睛事件
- (IBAction)eyeBtnAction:(id)sender {
    UIButton *btn = sender;
    if (btn.selected) {
        self.password.secureTextEntry = YES;
        btn.selected = NO;
    }else {
        self.password.secureTextEntry = NO;
        btn.selected = YES;
    }
}

@end
