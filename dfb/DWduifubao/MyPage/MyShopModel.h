//
//  MyShopModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MyShopModel : NSObject
///商铺Id
@property (nonatomic, assign) int merchant_id ;
///店铺名称
@property (nonatomic, strong) NSString *merchant_name ;
///店铺logo
@property (nonatomic, strong) NSString *merchant_logo ;
///联系电话
@property (nonatomic, strong) NSString *merchant_mobile ;
///简介
@property (nonatomic, strong) NSString *content;
///开店时间
@property (nonatomic, strong) NSString *create_time ;
///店铺关注数量
@property (nonatomic, strong) NSString *collect_peoples ;

///是否关注0否/1是

@property (nonatomic, strong) NSString *is_collect
 ;
///店铺地址
@property (nonatomic, strong) NSString *address ;
///地区 省市区
@property (nonatomic, strong) NSString *zone ;
///店铺底图
@property (nonatomic, strong) NSString  *main_image ;





@end
