//
//  IndianaHomeTwoVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaHomeTwoVC.h"
#import "IndianaShopModel.h"
@implementation IndianaHomeTwoVC

- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    //self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
    self.OneBtn.layer.masksToBounds = YES;
    self.OneBtn.layer.cornerRadius =5.f;
    self.OneBtn.layer.borderWidth = 0.8f;
    self.OneBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.progressV.userInteractionEnabled = NO;
    self.progressV.progress = 0.8;
    self.progressV.gradientColors = @[[UIColor colorWithHexString:@"#ffad45"],[UIColor colorWithHexString:kRedColor]];
    self.progressV.edgeColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.progressV.bgColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //[self.goods_image.layer setLaberMasksToBounds:YES cornerRadius:3.0 borderWidth:0.8 borderColor:[UIColor colorWithHexString:kViewBackgroundColor]];
    
}
-(void)setModel:(IndianaShopModel *)model{
    if (!model) return;
    _model = model;
    [_goods_image SD_WebimageUrlStr:_model.goods_image placeholderImage:nil];
    _goods_name.text = model.goods_name;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度 %@%%",model.schedule]];
    
            [AttributedStr addAttribute:NSFontAttributeName
    
                                      value:[UIFont systemFontOfSize:13]
    
                                      range:NSMakeRange(5, model.schedule.length+1)];
    
                [AttributedStr addAttribute:NSForegroundColorAttributeName
    
                                      value:[UIColor colorWithHexString:@"#1757ae"]
    
                                      range:NSMakeRange(5, model.schedule.length+1)];
    
    _schedule.attributedText = AttributedStr;
    self.progressV.progress =[_model.schedule floatValue]/100 ;

    
    
}
@end

