//
//  IndianaShopDetailsThreeCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaShopDetailsThreeCell.h"
#import "IndianaShopModel.h"
@interface IndianaShopDetailsThreeCell ()
///剩余
@property(nonatomic,assign) int remaining;
@end
@implementation IndianaShopDetailsThreeCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self. historyBtn setImagePosition:LXMImagePositionRight spacing:3];

    //Cell背景颜色
    self.AddAndDelView.layer.cornerRadius= 3.0;
    self.AddAndDelView.layer.masksToBounds = YES;
    self.AddAndDelView.layer.borderWidth= 1.0;
    self.AddAndDelView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textTf.userInteractionEnabled = YES;
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
    self.remaining =0;

}
- (IBAction)deleteACtion:(PublicBtn *)sender {
    int a=  [self.textTf.text intValue];
    
    if ([self.textTf.text intValue]>1) {
        a--;
        self.textTf.text = [NSString stringWithFormat:@"%d",a];
        
    }
    self. IndianaShopDetailsNumberCellBlock(self.textTf.text);
}
- (IBAction)addAction:(PublicBtn *)sender {
    int a=  [self.textTf.text intValue];
    if ([self.textTf.text intValue]>0) {
        a++;
        self.textTf.text = [NSString stringWithFormat:@"%d",a];
    }
    if ([self.textTf.text intValue]>self.remaining) {
        self.textTf.text=[NSString stringWithFormat:@"%d",self.remaining];
        [DWToastTool showToast:[NSString stringWithFormat:@"仅剩余%d人次",self.remaining]];
    }

    self. IndianaShopDetailsNumberCellBlock(self.textTf.text);
}
- (IBAction)TFChangeACtion:(PublicTF *)sender {
    if (sender.text.length==0||[self.textTf.text intValue]==0) {
        sender.text=@"1";
    }
    if ([self.textTf.text intValue]>self.remaining) {
        sender.text=[NSString stringWithFormat:@"%d",self.remaining];
        [DWToastTool showToast:[NSString stringWithFormat:@"仅剩余%d人次",self.remaining]];
    }    
    int a=  [self.textTf.text intValue];
    self.textTf.text = [NSString stringWithFormat:@"%d",a];
    self.IndianaShopDetailsNumberCellBlock(self.textTf.text);
}


- (IBAction)BtnAction:(UIButton *)sender {
    
    self.IndianaShopDetailsThreeCellBlock(sender.tag-510);
}
-(void)setModel:(IndianaShopModel *)model{
    if (!model) return;
    
    _model = model;
    self.remaining = [model.counts intValue]-[model.players intValue];
    _start_time.text = [NSString stringWithFormat:@"%@开始",model.start_time ];
    _announce.text = @"声明: 所有活动及商品均与苹果公司无关";
}
@end
