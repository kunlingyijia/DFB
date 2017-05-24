//
//  OrderDetailTwoCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderDetailTwoCell.h"
#import "OrderModel.h"
@implementation OrderDetailTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(OrderModel*)model{
    _merchant_name.text = model.merchant_name;
}
@end
