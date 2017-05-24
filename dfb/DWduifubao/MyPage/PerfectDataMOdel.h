//
//  PerfectDataMOdel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/2.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerfectDataMOdel : NSObject
///店名
@property (nonatomic, strong) NSString *merchant_name ;
///手机号
@property (nonatomic, strong) NSString *merchant_mobile ;
///简介
@property (nonatomic, strong) NSString *content ;
///店铺logo图url
@property (nonatomic, strong) NSString *merchant_logo ;
///店铺id（修改填）
@property (nonatomic, strong) NSString *merchant_id ;
///1-添加 2-修改
@property (nonatomic, strong) NSString *type ;
///银行卡开户行
@property (nonatomic, strong) NSString *bank_name ;
///银行卡号
@property (nonatomic, strong) NSString *bank_account_number ;
///营业执照
@property (nonatomic, strong) NSString *license_url ;
///营业执照号码
@property (nonatomic, strong) NSString *license_no ;
///法人身份证正面url
@property (nonatomic, strong) NSString *id_card_photo ;
///法人身份证反面
@property (nonatomic, strong) NSString *id_card_back_photo ;
///法人身份证号码
@property (nonatomic, strong) NSString *id_card ;
///银行卡正面url
@property (nonatomic, strong) NSString *bank_card_photo ;
///支行
@property (nonatomic, strong) NSString *subbranch ;
///银联号
@property (nonatomic, strong) NSString  *bank_branch_no ;



///店铺地址
@property (nonatomic, strong) NSString *address ;
///省份id
@property (nonatomic, strong) NSString *province_id ;
///城市id
@property (nonatomic, strong) NSString *city_id ;
///区域id
@property (nonatomic, strong) NSString *region_id ;
///地区 省市区
@property (nonatomic, strong) NSString *zone ;
///行业分类id
@property (nonatomic, strong) NSString *industry_id ;
///行业名称
@property (nonatomic, strong) NSString *industry_name ;











@end
