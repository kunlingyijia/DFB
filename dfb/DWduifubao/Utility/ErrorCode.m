//
//  ErrorCode.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/20.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ErrorCode.h"
#import "BaseResponse.h"

@implementation ErrorCode

- (void)showErrorCodeWithBaseResponse:(BaseResponse *)baseRes withBaseController:(BaseViewController *)vc {
    NSInteger errorCode = baseRes.resultCode;
    NSString *str = nil;
    switch (errorCode) {
        case 3:
            str = @"账号或密码错误";
            break;
        case 4:
            str = @"请填写正确的手机号码";
            break;
        case 5:
            str = @"密码不能为空";
            break;
        case 6:
            str = @"验证码不能为空";
            break;
        case 7:
            str = @"验证码不正确";
            break;
        case 8:
            str = @"请登录";
            break;
        case 9:
            str = @"短信发送失败";
            break;
        case 10:
            str = @"验证码已经过期,请重新获取";
            break;
        case 11:
            str = @"手机号已经注册";
            break;
        case 12:
            str = @"账号不存在";
            break;
        case 13:
            str = @"异常";
            break;
        case 14:
            str = @"异常";
            break;
        case 15:
            str = @"异常";
            break;
        case 16:
            str = @"异常";
            break;
        case 17:
            str = @"请填写反馈内容";
            break;
        case 18:
            str = @"已经签到过";
            break;
        case 19:
            str = @"系统异常";
            break;
        case 20:
            str = @"没有文件上传";
            break;
        case 21:
            str = @"请勿重复绑定";
            break;
        case 22:
            str = @"第三方绑定异常";
            break;
        case 23:
            str = @"账号或密码不能为空";
            break;
        case 24:
            str = @"账号异常";
            break;
        case 25:
            str = @"系统异常";
            break;
        case 26:
            str = @"暂无数据";
            break;
        case 27:
            str = @"邀请人不存在";
            break;
        case 28:
            str = @"商户类型错误";
            break;
        case 29:
            str = @"地区Id异常";
            break;
        case 30:
            str = @"旧密码错误";
            break;
        case 31:
            str = @"获取参数错误";
            break;
            
        default:
            break;
    }
    [vc showToast:str];
}

@end
