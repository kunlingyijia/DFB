//
//  DWBanKMainCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWBanKMainCell.h"

@implementation DWBanKMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.Bank_nameLabel.textColor = [UIColor redColor];
    }else{
        self.Bank_nameLabel.textColor = [UIColor blackColor];
    }

    // Configure the view for the selected state
}

@end
