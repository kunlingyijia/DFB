//
//  IndianaClassOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaClassOneCell.h"
#import "IndianaShopClassModel.h"
@implementation IndianaClassOneCell

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
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
    //[self.icon_url.layer setLaberMasksToBounds:YES cornerRadius:3.0 borderWidth:0.8 borderColor:[UIColor lightGrayColor]];
}
-(void)setModel:(IndianaShopClassModel *)model{
    if (!model) return;
    _model = model;
    self.category_name.text = _model.category_name;
    [self.icon_url SD_WebimageUrlStr:_model.icon_url placeholderImage:nil];
    
}
@end
