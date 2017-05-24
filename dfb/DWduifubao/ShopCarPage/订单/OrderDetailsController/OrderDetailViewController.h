//
//  OrderDetailViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;
///支付时倒计时
@property (weak, nonatomic) IBOutlet UILabel *time_remain;

///订单号
@property (nonatomic, strong) NSString  *order_no ;


@end
