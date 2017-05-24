//
//  DWBankCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWBankCell.h"

@implementation DWBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self. textLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = [UIColor redColor];
    }else{
       self.textLabel.textColor = [UIColor blackColor];
    }
    // Configure the view for the selected state
}

@end
