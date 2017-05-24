//
//  UpdatePhoneController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdatePhoneController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextView *nowPhone;            //当前手机号
@property (weak, nonatomic) IBOutlet UITextField *resetPhone;         //新手机号
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;   //验证码

- (IBAction)getVerificationCodeBtnAction:(id)sender;  //"获取验证码"的按钮事件
- (IBAction)updateBtnAction:(id)sender;               //"更换"的按钮事件

@end
