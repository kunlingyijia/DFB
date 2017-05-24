//
//  MerchantsHomePageOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MerchantsHomePageOneCell.h"
#import "MerchantCertificationModel.h"
@implementation MerchantsHomePageOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.
   contentView. backgroundColor = [UIColor colorWithHexString:@"EB3237"];
}
-(void)CellGetData:(MerchantCertificationModel*)model{
    self.tdy_order_count.text = [NSString stringWithFormat:@"%@单",model.tdy_order_count];
    self.tdy_order_money.text = [NSString stringWithFormat:@"%@元",model.tdy_order_money];
     self.balance.text = [NSString stringWithFormat:@"%@元",model.balance];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
