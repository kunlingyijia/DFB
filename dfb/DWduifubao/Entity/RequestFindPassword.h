//
//  RequestFindPassword.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/8.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestFindPassword : NSObject

@property (nonatomic, copy) NSString *mobile;       //手机号
@property (nonatomic, copy) NSString *password;     //密码
@property (nonatomic, copy) NSString *verify_code;  //验证码
///手势密码
@property (nonatomic, strong) NSString  *handle_password ;
///type 1-验证 2-设置
@property (nonatomic, strong) NSString  *type ;





@end
