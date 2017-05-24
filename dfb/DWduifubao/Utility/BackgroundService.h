//
//  BackgroundService.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MySelf)();
typedef void (^MySelfPeiZhi)();
@interface BackgroundService : NSObject
///myself
@property (nonatomic, copy) MySelf  myself ;
///MySelfPeiZhi
@property (nonatomic, copy) MySelfPeiZhi  myselfPeizhi ;
+ (void)loginWhileTokeInvalid;
///获取个人资料
+(void)requestPushVC:(BaseViewController*)VC MyselfAction:(MySelf)myself;
+(void)PeizhiPushVC:(BaseViewController*)VC RequestAction:(MySelfPeiZhi)PeiZhi;
///inviter_code


@end
