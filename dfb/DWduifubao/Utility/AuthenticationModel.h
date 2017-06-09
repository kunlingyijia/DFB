//
//  AuthenticationModel.h
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationModel : NSObject

+ (NSString *)getRegisterKey;
+ (NSString *)getRegistertoken;
+ (NSString *)getLoginKey;
+ (NSString *)getLoginToken;
+ (NSString *)getmyPassword;
#pragma mark - 个人信息
+ (NSString *)getRegionID;
+ (NSString *)getRegionName;
+ (NSString *)getUserID;
+(NSString*)getscore;
+(NSString*)getvirtual_glod;
+(NSString*)getcash;
+(NSString*)getPhoneNumber;
+(NSString*)getnick_name;
+(NSString*)getgender;
///银行卡号
+(NSString*)getbank_account_number;
//
+(NSString*)getidcard_status;
//支付码的状态
+(NSString*)getisset_paypwd;
///会员等级
+(NSString*)getuser_type;
///开店状态
+(NSString*)getopenshop_status;
+(NSString*)getis_handle_password;



#pragma mark - 个人配置信息
+(NSString*)getexchange_formula;
+(NSString*)getto_glod_param;
+(NSString*)getto_cash_param;
+(NSString*)getcash_to_gold;
+(NSString*)getcash_to_gold_formula;
+(NSString*)getdraw_formula;
+(NSString*)getdraw_param;
+(NSString*)getimage_hostname;
+(NSString*)getimage_account;
+(NSString*)getimage_password;
+(NSString*)getto_virtual_glod;
+(NSString*)getcash_exchange_tax;
+(NSString*)getcash_draw_tax;
+(NSString*)geto2o_url;
+(NSString*)getinvite_url;
+(NSString*)getuser_tree;
+(NSString*)getupgrade_money;
+(NSString*)getinvite_description;
+(NSString*)getinvite_image;
+(NSString*)getinvite_title;
//会员升级说明
+(NSString*)getupgrade_intro;
+(NSArray*)getmember_menu;
#pragma mark - 其他配置
+(NSString*)getregister_url;//注册协议
+(NSString*)gethelp_url;//帮助中心
+(NSString*)getauth_url;//权限说明
#pragma mark - 移除
+(void)moveLoginKey;
+(void)moveLoginToken;

//购物车数量
+(NSString*)getCarNumber;
+(void)moveCarNumber;
//数据存储
+(void)setValue:(id)response forkey:(NSString*)key;
+(id)objectForKey:(NSString*)key;
//夺宝手机号
+(NSString*)getindiana_moblie;



@end
