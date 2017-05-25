//
//  CalculationDetailsOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "CalculationDetailsOneCell.h"
#import "IndianaUserSunModel.h"
@implementation CalculationDetailsOneCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    //self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(IndianaUserSunModel *)model{
    if (!model) return;
    _model = model;
    _create_time.text = model.create_time;
    _time_stamp.text = model.time_stamp;
    _nick_name.text = model.nick_name;

}
@end
