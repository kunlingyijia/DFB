//
//  SetPayPasswordController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface SetPayPasswordController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *phone;              //账号
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;  //验证码
@property (weak, nonatomic) IBOutlet UITextField *setPayPassword;    //设置支付密码

- (IBAction)getVerificationCodeBtnAction:(id)sender;  //"获取验证码"的按钮事件
- (IBAction)confirmBtnAction:(id)sender;              //"确定"的按钮事件
///act
@property (nonatomic, strong) NSString *act ;


@end
