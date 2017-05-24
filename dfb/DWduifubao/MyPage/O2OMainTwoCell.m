//
//  O2OMainTwoCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OMainTwoCell.h"
#import "O2OModel.h"
@implementation O2OMainTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(O2OModel*)model{
    self.order_no.text = model.order_no;
    self.pay_time.text = model.create_time;
    self.pay_title.text = model.pay_name;
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"未支付";
    }else if ([model.status isEqualToString:@"2"]) {
        self.status.text = @"支付成功";
    }else if ([model.status isEqualToString:@"3"]) {
        self.status.text = @"支付中";
    }else if ([model.status isEqualToString:@"3"]) {
        self.status.text = @"支付失败";
    }else{
        
    }
    
    self.amount.text =[NSString stringWithFormat:@"%.2f", [model.amount floatValue]];
    
    [DWHelper SD_WebImage:self.pay_iconImg imageUrlStr:model.pay_icon placeholderImage:nil];
}
@end
