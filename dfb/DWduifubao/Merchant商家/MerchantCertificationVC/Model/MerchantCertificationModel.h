//
//  MerchantCertificationModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantCertificationModel : NSObject

///店铺邮箱
@property (nonatomic, strong) NSString  *email ;


///店名
@property (nonatomic, strong) NSString  *merchant_name ;

///手机号
@property (nonatomic, strong) NSString  *merchant_mobile	 ;

///简介
@property (nonatomic, strong) NSString  *content;

///	店铺logo图url
@property (nonatomic, strong) NSString  *merchant_logo;

///店铺主图
@property (nonatomic, strong) NSString  *main_image;

///店铺id（修改填）
@property (nonatomic, strong) NSString  *merchant_id;

///1-添加 2-修改 (在拒绝时候选择修改)
@property (nonatomic, strong) NSString  *edit_type ;

///银行卡开户行
@property (nonatomic, strong) NSString  *bank_name;
///银行卡号
@property (nonatomic, strong) NSString  *bank_account_number	 ;
///营业执照
@property (nonatomic, strong) NSString  *license_url	 ;
///营业执照号码
@property (nonatomic, strong) NSString  *license_no ;

///法人身份证正面url
@property (nonatomic, strong) NSString  *id_card_photo ;

///法人身份证反面url
@property (nonatomic, strong) NSString  *id_card_back_photo ;

///法人身份证号码
@property (nonatomic, strong) NSString  *id_card ;
///开户名 法人姓名
@property (nonatomic, strong) NSString  *account_name;


///银行卡正面url
@property (nonatomic, strong) NSString  *bank_card_photo;
///支行
@property (nonatomic, strong) NSString  *subbranch ;
///店铺地址
@property (nonatomic, strong) NSString  *address	;
///省份id
@property (nonatomic, strong) NSString  *province_id ;
///城市id
@property (nonatomic, strong) NSString  *city_id ;
///区域id
@property (nonatomic, strong) NSString  *region_id ;

///地区 省市区
@property (nonatomic, strong) NSString  *zone ;



///行业名称
@property (nonatomic, strong) NSString  *industry_name ;


///行业分类id
@property (nonatomic, strong) NSString  *industry_id ;
///银行行号（银联号）
@property (nonatomic, strong) NSString  *bank_branch_no;

///状态 2- 对私 1- 对公;
@property (nonatomic, strong) NSString  *bank_card_type ;
///账户金额
@property (nonatomic, strong) NSString  *amount ;
///备注
@property (nonatomic, strong) NSString  *remark ;
///时间Y-m-d H:i:s
@property (nonatomic, strong) NSString  *create_time ;
///1-收入，2-支出
@property (nonatomic, strong) NSString  *type ;

///1-待审核 2-通过 3--审核不通过(1、3状态表示其他卡情况)
@property (nonatomic, strong) NSString  *status ;

///修改的银行卡信息
@property (nonatomic, strong) NSDictionary  *other_bank ;

///今日订单数
@property (nonatomic, strong) NSString  *tdy_order_count ;
///今日预计收入
@property (nonatomic, strong) NSString  *tdy_order_money ;
///账户余额
@property (nonatomic, strong) NSString  *balance ;






















@end
