//
//  MyLoanOrCardOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MyLoanOrCardOneCell.h"

@implementation MyLoanOrCardOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
     self.selectionStyle = UITableViewCellSelectionStyleNone;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
