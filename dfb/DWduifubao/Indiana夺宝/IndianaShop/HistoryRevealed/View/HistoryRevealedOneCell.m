//
//  HistoryRevealedOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "HistoryRevealedOneCell.h"
#import "IndianaUserSunModel.h"
@implementation HistoryRevealedOneCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(IndianaUserSunModel *)model{
    if (!model) return;
    _model = model;
    
    _times_no.text = [NSString stringWithFormat:@"第%@期",model.times_no];
    _open_time.text = [NSString stringWithFormat:@"揭晓时间:%@",model.open_time];
     _name.text = [NSString stringWithFormat:@"幸运用户:%@",model.name];
    _luck_no.text = [NSString stringWithFormat:@"幸运号码:%@",model.luck_no];
    _number.text = [NSString stringWithFormat:@"参与人次:%@",model.number];
   
    
}
@end
