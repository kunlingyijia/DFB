//
//  RequestRegister.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/8.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestRegister : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *inviter_code;
@property (nonatomic, copy) NSString *verify_code;
@property (nonatomic, assign) NSInteger region_id;
@property (nonatomic, assign) NSInteger city_id;
@property (nonatomic, assign) NSInteger province_id;
@property (nonatomic, copy) NSString *pay_password;


@end
