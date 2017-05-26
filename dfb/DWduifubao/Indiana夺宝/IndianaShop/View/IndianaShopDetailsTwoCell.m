//
//  IndianaShopDetailsTwoCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaShopDetailsTwoCell.h"
#import "last_timeModel.h"
@implementation IndianaShopDetailsTwoCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5.0;
    self.submitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.submitBtn.layer.borderWidth = 1;
    //Cell背景颜色
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
    [self.avatar_url.layer setLaberMasksToBounds:YES cornerRadius:(Width*2/5)*0.3/2.0 borderWidth:0 borderColor:nil];
   
    
    
}
- (IBAction)submitBtn:(UIButton *)sender {
    self.IndianaShopDetailsTwoCellBlock(sender.tag-890);
}

-(void)setModel:(last_timeModel *)model{
    if (!model) return;

    _model = model;
    _win_name.text = model.win_name;
    _luck_no.text =[NSString stringWithFormat:@"幸运号码:%@", model.luck_no];
    _times_no.text =[NSString stringWithFormat:@"第%@期", model.times_no];
    _number.text =[NSString stringWithFormat:@"%@份", model.number];
    _open_time.text = model.open_time;
    [self.avatar_url SD_WebimageUrlStr:model.avatar_url placeholderImage:@"图层-15-拷贝-2"];
    
}
@end
