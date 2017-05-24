//
//  MerchantOrderListCell.m
//  自定义弹窗
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 席亚坤. All rights reserved.
//

#import "MerchantOrderListCell.h"
#import "OrderModel.h"
@implementation MerchantOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.ChaKan.layer.masksToBounds = YES;
    self.ChaKan.layer.cornerRadius = 5.0f;
    self.ChaKan.layer.borderWidth = 1;
    self.ChaKan.layer.borderColor = [UIColor redColor].CGColor;
    
    // Initialization code
}
///赋值
-(void)cellGetData:(OrderModel*)model{
   
   
    self.order_no.text = model.order_no;
    self.create_time.text = model.create_time;
    //订单状态：1-待付款 2-待发货  3-已发货  ,4-待评价，5-已完成
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"待付款";
        
    }else if ([model.status isEqualToString:@"2"]) {
        self.status.text = @"待发货";
        
    }else if ([model.status isEqualToString:@"3"]) {
        self.status.text = @"待收货";
        
    }else if ([model.status isEqualToString:@"4"]) {
        self.status.text = @"待评价";
    }else if ([model.status isEqualToString:@"5"]) {
        self.status.text = @"已完成";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
