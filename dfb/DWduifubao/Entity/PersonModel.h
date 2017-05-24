//
//  PersonModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/24.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject
///nick_name
@property (nonatomic, strong) NSString *nick_name ;
///gender
@property (nonatomic, strong) NSString *gender;
///avatar_url
@property (nonatomic, strong) NSString *avatar_url ;
///mobile
@property (nonatomic, strong) NSString * mobile ;
///user_type
@property (nonatomic, assign) NSInteger user_type;
///score积分
@property (nonatomic, assign) NSInteger score;
///dfglod兑富宝
@property (nonatomic, assign) CGFloat virtual_glod ;
///dfbao现金
@property (nonatomic, assign) CGFloat cash;
///idcard_status
@property (nonatomic, assign) NSInteger idcard_status;
///openshop_status
@property (nonatomic, assign) NSInteger openshop_status;
///openshop_remark
@property (nonatomic, assign) NSInteger openshop_remark;
///isset_paypwd
@property (nonatomic, assign) NSInteger isset_paypwd;
///new_progeny_num
@property (nonatomic, assign) NSInteger new_progeny_num;
///bank_account_number
@property (nonatomic, assign) NSInteger bank_account_number;
///inviter_code
@property (nonatomic, assign) NSInteger inviter_code;
///待付款
@property (nonatomic, strong) NSString  *dai_fu_kuan ;
///待发货

@property (nonatomic, strong) NSString  *dai_fa_huo ;
///待收货
@property (nonatomic, strong) NSString  *dai_shou_huo ;
///待评价
@property (nonatomic, strong) NSString  *dai_ping_jia ;
///已完成
@property (nonatomic, strong) NSString  *yi_wan_cheng ;


























@end
