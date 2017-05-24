//
//  LogisticsTwoCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LogisticsTwoCell.h"
#import "LogisticsModel.h"
@implementation LogisticsTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(LogisticsModel*)model{
    _context.text = model.context;
    _time.text = model.time;
}
@end
