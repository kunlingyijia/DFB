//
//  LogisticsOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LogisticsOneCell.h"
#import "OrderModel.h"
@implementation LogisticsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(OrderModel*)model{
    _logistics_no.text = model.logistics_no;
    _logistics_name.text = model.logistics_name;
}
@end
