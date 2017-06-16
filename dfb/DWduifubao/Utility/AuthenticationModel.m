//
//  AuthenticationModel.m
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AuthenticationModel.h"

@implementation AuthenticationModel
+ (NSString *)getRegisterKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"registKey"];
}
+ (NSString *)getRegistertoken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"registToken"];
}
+ (NSString *)getLoginKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"loginKey"];
}
+ (NSString *)getLoginToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"loginToken"];
}
//保存手势密码
+ (NSString *)getmyPassword{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"myPassword"];
}
#pragma mark - 个人信息
+ (NSString *)getRegionID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"regionId"];
}
+ (NSString *)getRegionName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"regionName"];
}

+ (NSString *)getUserID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"userID"];
}
+(NSString*)getPhoneNumber{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"loginmobile"];
}
+(NSString*)getnick_name{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"nick_name"];
}
+(NSString*)getgender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"gender"];
}

///银行卡号
+(NSString*)getbank_account_number{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"bank_account_number"];
}
+(NSString*)getscore{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"score"];
}
+(NSString*)getvirtual_glod{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"virtual_glod"];
}
+(NSString*)getcash{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"cash"];
}
+(NSString*)getidcard_status{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"idcard_status"];
}
+(NSString*)getisset_paypwd{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"isset_paypwd"];
    
    
    
}
+(NSString*)getuser_type{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"user_type"];
    
}

+(NSString*)getopenshop_status{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"openshop_status"];
}
+(NSString*)getis_handle_password{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"is_handle_password"];
}

#pragma mark - 配置信息
+(NSString*)getimage_hostname{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"image_hostname"];
}
+(NSString*)getimage_account{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"image_account"];
}
+(NSString*)getimage_password{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"image_password"];

}
+(NSString*)getto_virtual_glod{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"to_virtual_glod"];
}
+(NSString*)getcash_exchange_tax{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"cash_exchange_tax"];
}
+(NSString*)getcash_draw_tax{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"cash_draw_tax"];
}
+(NSString*)geto2o_url{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"o2o_url"];
}
+(NSString*)getinvite_url{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"invite_url"];
}
+(NSString*)getuser_tree{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"user_tree"];
}
+(NSString*)getupgrade_money{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"upgrade_money"];
}
+(NSString*)getinvite_description{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"invite_description"];
}

+(NSString*)getinvite_image{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"invite_image"];
}
+(NSString*)getinvite_title{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"invite_title"];
}
#pragma mark - 会员升级说明
+(NSString*)getupgrade_intro{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"upgrade_intro"];
}
+(NSArray*)getmember_menu{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"member_menu"];
}
+(NSString*)getexchange_formula{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"exchange_formula"];
}
+(NSString*)getto_glod_param{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"to_glod_param"];
}
+(NSString*)getto_cash_param{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"to_cash_param"];
}

+(NSString*)getcash_to_gold{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"cash_to_gold"];
}
+(NSString*)getcash_to_gold_formula{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"cash_to_gold_formula"];
}

+(NSString*)getdraw_formula{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"draw_formula"];
}
+(NSString*)getdraw_param{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"draw_param"];
}
#pragma mark - 其他配置
//注册协议
+(NSString*)getregister_url{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"register_url"];
}
//帮助中心
+(NSString*)gethelp_url{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"help_url"];
}
//权限说明
+(NSString*)getauth_url{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"auth_url"];
}
+(void)moveLoginKey{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults removeObjectForKey:  @"loginKey"];
}
+(void)moveLoginToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:  @"loginToken"];
}
#pragma mark -  购物车数量
+(NSString*)getCarNumber{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"CarNumber"];
}
#pragma mark - 移除购物车数量
+(void)moveCarNumber{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CarNumber"];
}

#pragma mark -  数据存储
+(void)setValue:(id)response forkey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults]setObject:[response yy_modelToJSONString] forKey:key];
}
+(id)objectForKey:(NSString*)key{
     NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (str.length!=0) {
        NSData * data= [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSMutableDictionary * dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        return dic[@"data"];

    }else{
        return nil;
    }
   
    
    
}


//夺宝手机号
+(NSString*)getindiana_moblie{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return  [userDefaults objectForKey:@"indiana_moblie"];
    
}
//删除
+(void)moveindiana_moblie{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"indiana_moblie"];
}
@end
