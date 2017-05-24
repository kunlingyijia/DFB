//
//  IndianaShopDetailsFourCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaShopDetailsFourCell.h"
#import "IndianaUserSunModel.h"
@implementation IndianaShopDetailsFourCell

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
//    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
    [_avatar_url.layer setLaberMasksToBounds:YES cornerRadius:3.0 borderWidth:0.8 borderColor:[UIColor colorWithHexString:kViewBackgroundColor]];
    
}
-(void)setModel:(IndianaUserSunModel *)model{
    if (!model) return;
    _model = model;
    [_avatar_url SD_WebimageUrlStr:model.avatar_url placeholderImage:nil];
    _nick_name.text = [NSString stringWithFormat:@"参与者  %@", model.nick_name ];
    // cell 其他配置
    NSString * str =[NSString stringWithFormat:@"(IP:%@)\n参与时间 :%@\n本期购买:%@份",_model.ip,_model.create_time,_model.number];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString: str] ;
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    [self.label setAttributedText:attributedString1];
}
@end
