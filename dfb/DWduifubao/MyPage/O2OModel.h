//
//  O2OModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface O2OModel : NSObject
///上月收款金额
@property (nonatomic, strong) NSString *last_o2o_money ;
///本月收款金额
@property (nonatomic, strong) NSString *current_o2o_money ;
///可提现金额
@property (nonatomic, assign) double draw_money ;
///订单id
@property (nonatomic, strong) NSString *order_id ;
///o2o商户id
@property (nonatomic, strong) NSString *o2o_merchant_id ;
///订单号
@property (nonatomic, strong) NSString *order_no ;

///支付通道  ZFBSMZF-支付宝支付 WXGZHZF-公众号 WXSMZF-微信

//@property (nonatomic, strong) NSString *pay_code ;
@property (nonatomic, strong) NSString *channel_pay ;
///金额 元
@property (nonatomic, strong) NSString *amount ;
///1-未支付 2-成功  3-支付中 4-支付失败

@property (nonatomic, strong) NSString *status ;
///支付链接（用于生成二维码）
@property (nonatomic, strong) NSString *qrcode_url ;
///创建时间
@property (nonatomic, strong) NSString *create_time	 ;
///支付时间
@property (nonatomic, strong) NSString *pay_time ;
///渠道类型：1-华付通
@property (nonatomic, strong) NSString *channel_type ;
///支付图标
@property (nonatomic, strong) NSString *pay_icon ;
///显示标题
@property (nonatomic, strong) NSString *pay_title ;
///支付配置id
@property (nonatomic, strong) NSString *pay_config_id ;
///支付名称
@property (nonatomic, strong) NSString *pay_name;

///单笔限额(信用卡)
@property (nonatomic, strong) NSString  *limit;
///允许提现时间
@property (nonatomic, strong) NSString  *withdraw_time ;










@end
