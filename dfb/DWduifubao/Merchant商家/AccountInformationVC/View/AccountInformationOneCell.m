//
//  AccountInformationOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "AccountInformationOneCell.h"
#import "MerchantCertificationModel.h"
@implementation AccountInformationOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)CellGetData:(MerchantCertificationModel *)model{
    self.remark.text = model.remark;
    ///1-收入，2-支出
    if ([model.type isEqualToString:@"1"]) {
        self.amount.text =[NSString stringWithFormat:@"+%@", model.amount ];
    }else{
        self.amount.text =[NSString stringWithFormat:@"-%@", model.amount ];
    }
    self.create_time.text = model.create_time;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
