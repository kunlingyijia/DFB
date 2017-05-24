//
//  SubmitAddressCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SubmitAddressCell.h"
#import "AddressModel.h"
@implementation SubmitAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
///赋值
-(void)cellGetData:(AddressModel*)model{
    self.name.text = model.name;
    NSString *tel = [model.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.mobile.text = tel;
    self.address.text = [NSString stringWithFormat:@"%@%@",model.zone,model.address];
}
@end
