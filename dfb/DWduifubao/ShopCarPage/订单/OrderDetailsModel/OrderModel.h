//
//  OrderModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/5.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
///订单号
@property (nonatomic, strong) NSString  *order_no
 ;
///商家id
@property (nonatomic, strong) NSString  *merchant_id ;
///商家名称
@property (nonatomic, strong) NSString  *merchant_name ;
///发货单号（status 3,4,5）
@property (nonatomic, strong) NSString  *logistics_no ;
///快递公司名称（status 3,4,5）
@property (nonatomic, strong) NSString  *logistics_name ;
///快递公司代码（status 3,4,5）
@property (nonatomic, strong) NSString  *logistics_com ;
///1-待付款 2-待发货  3-已发货  ,4-待评价，5-已完成
@property (nonatomic, strong) NSString  *status ;

///总价
@property (nonatomic, strong) NSString  *amount ;
///数量
@property (nonatomic, strong) NSString  *number ;

///收货人姓名
@property (nonatomic, strong) NSString *address_name ;
///	收货人电话号码
@property (nonatomic, strong) NSString *address_mobile ;
///详细地址
@property (nonatomic, strong) NSString *address ;
///备注
@property (nonatomic, strong) NSString  *remark ;

///下单时间
@property (nonatomic, strong) NSString  *create_time ;
///支付时间
@property (nonatomic, strong) NSString  *pay_time ;


///发货时间
@property (nonatomic, strong) NSString  *shipping_time ;


///收货时间
@property (nonatomic, strong) NSString  *confirm_time ;

///订单商品id
@property (nonatomic, strong) NSString  *order_goods_id;
///运费
@property (nonatomic, strong) NSString  *total_freight ;






@end
