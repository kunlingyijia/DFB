//
//  SecurityCertificateController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface SecurityCertificateController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *loginPasswordView;      //"登录密码"的View
@property (weak, nonatomic) IBOutlet UIView *phoneVerificationView;  //"手机验证"的View
@property (weak, nonatomic) IBOutlet UIView *setPayPasswordView;     //"设置支付密码"的View

@property (weak, nonatomic) IBOutlet UILabel *phone;   //验证的手机号

@end
