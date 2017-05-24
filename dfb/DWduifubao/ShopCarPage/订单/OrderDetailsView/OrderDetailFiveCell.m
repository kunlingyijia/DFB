//
//  OrderDetailFiveCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderDetailFiveCell.h"
#import "OrderModel.h"
@implementation OrderDetailFiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(OrderModel*)model{
    
    NSString * timeDetails = [[NSString alloc]init];
    
    if (model.create_time.length !=0) {
        timeDetails = [timeDetails stringByAppendingString:[NSString stringWithFormat: @"下单时间:%@\n",model.create_time]];
    }
    if(model.pay_time.length !=0) {
        timeDetails = [timeDetails stringByAppendingString:[NSString stringWithFormat:@"支付时间:%@\n",model.pay_time]];
    }
    if(model.shipping_time.length !=0) {
        timeDetails = [timeDetails stringByAppendingString:[NSString stringWithFormat:@"发货时间:%@\n",model.shipping_time]];
    }
    if(model.confirm_time.length !=0) {
        timeDetails =[timeDetails stringByAppendingString: [NSString stringWithFormat:@"收货时间:%@\n",model.confirm_time]];
    }

    
    _timeDetails.text = timeDetails;
}
@end
