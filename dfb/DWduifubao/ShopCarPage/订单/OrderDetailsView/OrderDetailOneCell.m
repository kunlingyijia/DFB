//
//  OrderDetailOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderDetailOneCell.h"
#import "OrderModel.h"
@implementation OrderDetailOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor=[UIColor colorWithHexString:kViewBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
///赋值
-(void)cellGetData:(OrderModel*)model{
    self.name.text = model.address_name;
    NSString *tel = [model.address_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.mobile.text = tel;
    self.address.text = [NSString stringWithFormat:@"%@",model.address];
    self.order_no.text = model.order_no;
    
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

@end
