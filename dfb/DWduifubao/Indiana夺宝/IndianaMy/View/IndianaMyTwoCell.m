//
//  IndianaMyTwoCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaMyTwoCell.h"
#import "IndianaUserSunModel.h"
@implementation IndianaMyTwoCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    //self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
    
}
-(void)setModel:(IndianaUserSunModel *)model{
    if (!model) return;
    _model = model;
    [_avatar_url.layer setLaberMasksToBounds:YES cornerRadius:_avatar_url.frame.size.width/2.0 borderWidth:0 borderColor:nil];
    [_avatar_url SD_WebimageUrlStr:model.avatar_url placeholderImage:@"图层-15-拷贝-2"];
    _nick_name.text = model.nick_name;
    _create_time.text  = model.create_time;
    _goods_name.text = model.goods_name;
    _times_no.text = [NSString stringWithFormat:@"期号: 第%@期",model.times_no];
    
   
    
    _content.text = model.content;
    
    
    
    
}
@end

