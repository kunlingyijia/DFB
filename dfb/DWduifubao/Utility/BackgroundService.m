//
//  BackgroundService.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BackgroundService.h"
#import "RequestLogin.h"
@implementation BackgroundService
+ (void)loginWhileTokeInvalid{
    NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
    NSString *moblie = [userDefau objectForKey:@"user_moblie"];
    NSString *password = [userDefau objectForKey:@"user_password"];
    NSLog(@"%@",password);
    if (moblie && password) {
    RequestLogin *login = [[RequestLogin alloc] init];
    login.mobile = moblie;
    login.password = password;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = login;
    //__weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Login sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:nil success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            NSDictionary *dic = baseRes.data;
            NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
            [userDefau setObject:dic[@"key"] forKey:@"loginKey"];
            [userDefau setObject:dic[@"token"] forKey:@"loginToken"];
            NSString *pushAlias
            =baseRes.data[@"pushAlias"];
            if (pushAlias.length>0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:baseRes.data[@"pushAlias"] forKey:@"pushAlias"]];
            }
           // NSLog(@"%@",[AuthenticationModel getPhoneNumber]);
            //请求配置信息网络请求
           // [weakself PeizhiRequestAction];
//            [weakself PeizhiRequestAction:^{
//                
//            }];
            
        }else if(baseRes.resultCode == 3) {
            NSLog(@"触发了");
            [[NSUserDefaults standardUserDefaults]removeObjectForKey :@"user_password"];

        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
        
    }
    
    
}

#pragma mark - 请求配置信息网络请求
+(void)PeizhiPushVC:(BaseViewController*)VC RequestAction:(MySelfPeiZhi)PeiZhi{
    //控件赋值
    NSString *Token =[AuthenticationModel getLoginToken];
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/System/config" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:VC success:^(id response) {
            NSLog(@"%@",response);
            //控件赋值
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"配置--数据存储%@", response);
            if (baseRes.resultCode == 1) {
                //配置--数据存储
             NSDictionary *dic = baseRes.data;
                NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
                if ([dic[@"image_hostname"]isKindOfClass:[NSNull class]]) {
                }else{
                  [userDefau setObject:dic[@"image_hostname"] forKey:@"image_hostname"];
                }
                if ([dic[@"image_account"]isKindOfClass:[NSNull class]]) {
                    
                }else{
                    [userDefau setObject:dic[@"image_account"] forKey:@"image_account"];
                }
 
                if ([dic[@"image_password"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"image_password"] forKey:@"image_password"];
                }
                
            //  [userDefau setObject:dic[@"to_virtual_glod"] forKey:@"to_virtual_glod"];
                if ([dic[@"to_virtual_glod"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"to_virtual_glod"] forKey:@"to_virtual_glod"];
                }
                //[userDefau setObject:dic[@"cash_exchange_tax"] forKey:@"cash_exchange_tax"];
                if ([dic[@"cash_exchange_tax"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"cash_exchange_tax"] forKey:@"cash_exchange_tax"];
                }

                //[userDefau setObject:dic[@"cash_draw_tax"] forKey:@"cash_draw_tax"];
                if ([dic[@"cash_draw_tax"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"cash_draw_tax"] forKey:@"cash_draw_tax"];
                }
               // [userDefau setObject:dic[@"o2o_url"] forKey:@"o2o_url"];
                if ([dic[@"o2o_url"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"o2o_url"] forKey:@"o2o_url"];
                }
                //[userDefau setObject:dic[@"invite_url"] forKey:@"invite_url"];
                if ([dic[@"invite_url"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"invite_url"] forKey:@"invite_url"];
                }
               // [userDefau setObject:dic[@"user_tree"] forKey:@"user_tree"];
                if ([dic[@"user_tree"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"user_tree"] forKey:@"user_tree"];
                }
               // [userDefau setObject:dic[@"upgrade_money"] forKey:@"upgrade_money"];
                if ([dic[@"upgrade_money"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"upgrade_money"] forKey:@"upgrade_money"];
                }

                //[userDefau setObject:dic[@"invite_description"] forKey:@"invite_description"];
                if ([dic[@"invite_description"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"invite_description"] forKey:@"invite_description"];
                }
                //[userDefau setObject:dic[@"invite_title"] forKey:@"invite_title"];
                if ([dic[@"invite_title"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"invite_title"] forKey:@"invite_title"];
                }
                
                //[userDefau setObject:dic[@"invite_image"] forKey:@"invite_image"];
                if ([dic[@"invite_image"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"invite_image"] forKey:@"invite_image"];
                }
                //配置最新的draw_formula
               // [userDefau setObject:dic[@"exchange_formula"] forKey:@"exchange_formula"];
                if ([dic[@"exchange_formula"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"exchange_formula"] forKey:@"exchange_formula"];
                }

                //[userDefau setObject:dic[@"to_glod_param"] forKey:@"to_glod_param"];
                if ([dic[@"to_glod_param"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"to_glod_param"] forKey:@"to_glod_param"];
                }
               // [userDefau setObject:dic[@"to_cash_param"] forKey:@"to_cash_param"];
                if ([dic[@"to_cash_param"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"to_cash_param"] forKey:@"to_cash_param"];
                }
                if ([dic[@"cash_to_gold"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"cash_to_gold"] forKey:@"cash_to_gold"];
                }
                
                if ([dic[ @"cash_to_gold_formula"
]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[ @"cash_to_gold_formula"
                                             ] forKey: @"cash_to_gold_formula"
];
                }

                               //[userDefau setObject:dic[@"draw_formula"] forKey:@"draw_formula"];
                if ([dic[@"draw_formula"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"draw_formula"] forKey:@"draw_formula"];
                }
               // [userDefau setObject:dic[@"draw_param"] forKey:@"draw_param"];
                if ([dic[@"draw_param"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"draw_param"] forKey:@"draw_param"];
                }
                
                
                if ([dic[@"upgrade_intro"]isKindOfClass:[NSNull class]]) {
                }else{
                    [userDefau setObject:dic[@"upgrade_intro"] forKey:@"upgrade_intro"];
                }
                if ([dic[@"member_menu"]isKindOfClass:[NSNull class]]) {
                }else{
                    
                    [userDefau setObject:dic[@"member_menu"] forKey:@"member_menu"];
                }

               
                
                
                PeiZhi();
            }else {
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    
}

#pragma mark - 获取个人信息
+(void)requestPushVC:(BaseViewController*)VC MyselfAction:(MySelf)myself{
    NSString *Token =[AuthenticationModel getLoginToken];

    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_UserInfo sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:VC  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"%@",response);
            if (baseRes.resultCode == 1) {
                NSDictionary *dic = baseRes.data;
#warning ---推送
        NSLog(@"扎更好========%@",dic[@"inviter_code"]);
//        [JPUSHService setAlias:dic[@"inviter_code"]
//                      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
//                                object:self];
                
                NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
                [userDefau setObject:dic[@"inviter_code"] forKey:@"inviter_code"];
                [userDefau setObject:dic[@"mobile"] forKey:@"loginmobile"];
                [userDefau setObject:dic[@"idcard_status"] forKey:@"idcard_status"];
                [userDefau setObject:dic[@"isset_paypwd"] forKey:@"isset_paypwd"];
                [userDefau setObject:dic[@"user_type"] forKey:@"user_type"];
                [userDefau setObject:dic[@"openshop_status"] forKey:@"openshop_status"];
                [userDefau setObject:dic[@"score"] forKey:@"score"];
                [userDefau setObject:dic[@"virtual_glod"] forKey:@"virtual_glod"];
                [userDefau setObject:dic[@"cash"] forKey:@"cash"];
                [userDefau setObject:dic[@"score"] forKey:@"score"];

                if ([dic[@"bank_account_number"] isEqual:[NSNull null]]) {
                }else{
                    [userDefau setObject:dic[@"bank_account_number"] forKey:@"bank_account_number"];
                }
                 [userDefau setObject:dic[@"nick_name"] forKey:@"nick_name"];
                 [userDefau setObject:dic[@"gender"] forKey:@"gender"];
                [userDefau setObject:dic[@"is_handle_password"] forKey:@"is_handle_password"];
                if ([dic[@"cart_num"]isKindOfClass:[NSNull class]]) {
                    
                }else{
                    [userDefau setObject:dic[@"cart_num"] forKey:@"CarNumber"];

                }


                myself();
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}
//- (void)tagsAliasCallback:(int)iResCode
//                     tags:(NSSet *)tags
//                    alias:(NSString *)alias {
//    
//    
//    
//    
//    if (iResCode == 6002) {
//        
//        [JPUSHService setAlias:[[NSUserDefaults standardUserDefaults]objectForKey:@"inviter_code"] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//    }
//
//    NSLog(@"push set alias success alisa = %@", alias);
//}
////请求配置信息网络请求
//-(void)PeizhiRequestAction{
//    //控件赋值
//    NSString *Token =[AuthenticationModel getLoginToken];
//    if (Token.length!= 0) {
//        BaseRequest *baseReq = [[BaseRequest alloc] init];
//        baseReq.token = [AuthenticationModel getLoginToken];
//        baseReq.encryptionType = AES;
//        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
//        __weak typeof(self) weakself = self;
//        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/System/config" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
//            // NSLog(@"%@",response);
//            //控件赋值
//            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
//           // NSLog(@"------%@", response);
//            if (baseRes.resultCode == 1) {
//                //数据存储
//                [weakself SaveData:baseRes];
//                
//            }
//        } faild:^(id error) {
//            NSLog(@"%@", error);
//        }];
//        
//    }else {
//        
//    }
//    
//}
////数据保存
//-(void)SaveData:(BaseResponse*)baseRes{
//    
//    NSDictionary *dic = baseRes.data;
//    NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
//    [userDefau setObject:dic[@"image_hostname"] forKey:@"image_hostname"];
//    [userDefau setObject:dic[@"image_account"] forKey:@"image_account"];
//    [userDefau setObject:dic[@"image_password"] forKey:@"image_password"];
//    
//    [userDefau setObject:dic[@"to_virtual_glod"] forKey:@"to_virtual_glod"];
//    
//    [userDefau setObject:dic[@"cash_exchange_tax"] forKey:@"cash_exchange_tax"];
//    [userDefau setObject:dic[@"cash_draw_tax"] forKey:@"cash_draw_tax"];
//    [userDefau setObject:dic[@"o2o_url"] forKey:@"o2o_url"];
//    [userDefau setObject:dic[@"invite_url"] forKey:@"invite_url"];
//    [userDefau setObject:dic[@"user_tree"] forKey:@"user_tree"];
//    [userDefau setObject:dic[@"upgrade_money"] forKey:@"upgrade_money"];
//    [userDefau setObject:dic[@"invite_description"] forKey:@"invite_description"];
//    [userDefau setObject:dic[@"invite_title"] forKey:@"invite_title"];
//    [userDefau setObject:dic[@"invite_image"] forKey:@"invite_image"];
//    
//    //配置最新的draw_formula
//    [userDefau setObject:dic[@"exchange_formula"] forKey:@"exchange_formula"];
//    [userDefau setObject:dic[@"to_glod_param"] forKey:@"to_glod_param"];
//    [userDefau setObject:dic[@"to_cash_param"] forKey:@"to_cash_param"];
//    [userDefau setObject:dic[@"draw_formula"] forKey:@"draw_formula"];
//    [userDefau setObject:dic[@"draw_param"] forKey:@"draw_param"];
//    
//    
//}


@end
