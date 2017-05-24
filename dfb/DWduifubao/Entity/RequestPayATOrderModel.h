//
//  RequestPayATOrderModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestPayATOrderModel : NSObject
//order_no	xxx	string	64	订单号
//pay_amount			11	支付金额
//goodsName			145	商品名称
//prealipay		string		预支付支付宝
///订单号
@property (nonatomic, strong) NSString *order_no ;

///支付金额
@property (nonatomic, assign)CGFloat  pay_amount ;

///商品名称
@property (nonatomic, strong) NSString *goodsName ;
///预支付支付宝
@property (nonatomic, strong) NSString *prealipay ;





@end
