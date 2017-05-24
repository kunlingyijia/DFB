//
//  OrderDetailFourCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderDetailFourCell.h"
#import "OrderModel.h"
@implementation OrderDetailFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(OrderModel*)model{
    CGFloat amount= [ model.amount floatValue];
    CGFloat total_freight= [ model.total_freight floatValue];
    _AllPrice.text = [NSString stringWithFormat:@"%.2f", amount-total_freight];
    _amount.text = model.amount;
    _remark.text = model.remark;
    if ([(NSString*) model.total_freight floatValue]>0.0) {
        _freightStatusLabel.text = @"运费:";
    }else{
        _freightStatusLabel.text = @"运费:包邮";
    }
    _freightLabel.text =[NSString stringWithFormat:@"+%@", model.total_freight];

}
@end
