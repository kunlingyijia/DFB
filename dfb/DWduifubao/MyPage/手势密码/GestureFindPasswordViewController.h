//
//  GestureFindPasswordViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface GestureFindPasswordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;          //账号
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;  //验证码
///跳转来源
@property (nonatomic, strong) NSString  *pushSource;


@end
