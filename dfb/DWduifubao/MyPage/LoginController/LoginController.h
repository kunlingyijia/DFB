//
//  LoginController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/8.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^LoginRefresh)();
@interface LoginController : BaseViewController
///登录的Block
@property (nonatomic, copy) LoginRefresh  loginRefresh ;


-(void)LoginRefreshAction:(LoginRefresh)loginRefresh;
@property (weak, nonatomic) IBOutlet UITextField *userName;   //账号
@property (weak, nonatomic) IBOutlet UITextField *password;   //密码

- (IBAction)loginBtnClick:(id)sender;         //登录事件
- (IBAction)registerBtnClick:(id)sender;      //注册事件
- (IBAction)findPasswordBtnClick:(id)sender;  //找回密码事件

- (IBAction)eyeBtnAction:(id)sender;  //眼睛可视事件

@end
