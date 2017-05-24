//
//  PersonRenZhengModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonRenZhengModel : NSObject
///real_name
@property (nonatomic, strong) NSString *real_name ;
///身份张号
@property (nonatomic, strong) NSString *id_card ;
///bank_account_number
@property (nonatomic, strong) NSString *bank_account_number ;
///开户行
@property (nonatomic, strong) NSString *bank_name ;
///开户名

@property (nonatomic, strong) NSString *account_name ;
///正面照
@property (nonatomic, strong) NSString *bank_card_photo ;
///银行卡反面
@property (nonatomic, strong) NSString  *bank_card_back_photo ;
///id_card_photo
@property (nonatomic, strong) NSString *id_card_photo ;

///id_card_back_photo
@property (nonatomic, strong) NSString *id_card_back_photo ;
///person_photo
@property (nonatomic, strong) NSString *person_photo ;

///省id
@property (nonatomic, strong) NSString *province_id ;
///省名称
@property (nonatomic, strong) NSString  *provide ;
///市id
@property (nonatomic, strong) NSString *city_id ;
///市名称
@property (nonatomic, strong) NSString  *city ;
///区id
@property (nonatomic, strong) NSString *region_id ;
///区县名称
@property (nonatomic, strong) NSString  *area ;
///省市区
@property (nonatomic, strong) NSString *zone ;
///添加/修改 1/2
@property (nonatomic, strong) NSString *type ;
///主键id（修改填）
@property (nonatomic, strong) NSString *cer_id ;
///支行
@property (nonatomic, strong) NSString *subbranch ;

///支行行号
@property (nonatomic, strong) NSString *bank_branch_no ;

///支付密码
@property (nonatomic, strong) NSString  *pay_password ;
///错误信息
@property (nonatomic, strong) NSString  *content ;
///银行卡修改状态
@property (nonatomic, strong) NSString  *status ;

///新老客户
@property (nonatomic, strong) NSString  *is_old ;
///详细地址
@property (nonatomic, strong) NSString  *address ;

///银行卡预留电话
@property (nonatomic, strong) NSString  *reserved_mobile ;


















@end
