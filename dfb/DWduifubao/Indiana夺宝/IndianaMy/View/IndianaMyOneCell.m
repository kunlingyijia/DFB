//
//  IndianaMyOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaMyOneCell.h"
#import "IndianaUserSunModel.h"
@implementation IndianaMyOneCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.OneBtn.layer.masksToBounds = YES;
    self.OneBtn.layer.cornerRadius =5.f;
    self.OneBtn.layer.borderWidth = 0.8f;
    self.OneBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.Two.layer.masksToBounds = YES;
    self.Two.layer.cornerRadius =5.f;
    self.Two.layer.borderWidth = 0.8f;
    self.Two.layer.borderColor = [UIColor grayColor].CGColor;
    //Cell背景颜色
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}

- (IBAction)BtnAction:(PublicBtn *)sender {
    _IndianaMyOneCellBlock(sender.tag-410);
}


-(void)setModel:(IndianaUserSunModel*)model{
    if (!model) return;
    _model = model;
    [_goods_image SD_WebimageUrlStr:model.goods_image placeholderImage:nil];
    _goods_name.text = model.goods_name;
    // cell 其他配置
    NSString * countsAndtimes_no =[NSString stringWithFormat:@"总需人次: %@人次\n期        号: 第%@期",_model.counts,_model.times_no];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString: countsAndtimes_no] ;
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [countsAndtimes_no length])];
       _countsAndtimes_no.attributedText  =attributedString1;
    //_countsAndtimes_no.text =countsAndtimes_no;
    
    
    
    if ([model.status isEqualToString:@"2"]) {
        NSString * nick_nameAndluck_no =[NSString stringWithFormat:@"获  奖  者: %@\n幸运号码: %@",_model.nick_name,_model.luck_no];
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString: nick_nameAndluck_no] ;
        [attributedString2 addAttribute:NSForegroundColorAttributeName
         
                                  value:[UIColor blueColor]
         
                                  range:NSMakeRange(9, _model.nick_name.length)];
        [attributedString2 addAttribute:NSForegroundColorAttributeName
         
                                  value:[UIColor redColor]
         
                                  range:NSMakeRange(nick_nameAndluck_no.length-_model.luck_no.length, _model.luck_no.length)];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:5];
        [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [nick_nameAndluck_no length])];
        _nick_nameAndluck_no.attributedText  =attributedString2;
    }else{
       _nick_nameAndluck_no.attributedText  =[[NSMutableAttributedString alloc] init] ;
    }
    NSString *open_time =_model.open_time.length ==0 ? @"--:--:--" :_model.open_time;
    NSString * numberAndopen_time =[NSString stringWithFormat:@"本期参与: %@份\n揭晓时间: %@",_model.number,open_time ];
    NSMutableAttributedString * attributedString3 = [[NSMutableAttributedString alloc] initWithString: numberAndopen_time];
    [attributedString3 addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(numberAndopen_time.length-open_time.length, open_time.length)];
    NSMutableParagraphStyle * paragraphStyle3 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle3 setLineSpacing:5];
    [attributedString3 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle3 range:NSMakeRange(0, [numberAndopen_time length])];
    _numberAndopen_time.attributedText  =attributedString3;
    if ([model.status isEqualToString:@"2"]) {
         self.stadus.text = @"已中奖";
        //是否评价 0-否 1-是
        if ([model.is_comment isEqualToString:@"0"]) {
            self.OneBtn.hidden = NO;
        }else{
            self.OneBtn.hidden = YES;
        }
    }else{
        self.OneBtn.hidden = NO;
        if (model.open_time.length ==0) {
            self.stadus.text = @"等待揭晓";
        }else{
            self.stadus.text = @"未抢中";
        }

    }
    [self.OneBtn setTitle:[model.status isEqualToString:@"1"]  ? @"  幸运号码  ":@"   去晒单   " forState:(UIControlStateNormal)];

    
    
}
@end


