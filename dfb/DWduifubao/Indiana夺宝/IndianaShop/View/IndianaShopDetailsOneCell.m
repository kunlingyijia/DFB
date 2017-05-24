//
//  IndianaShopDetailsOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaShopDetailsOneCell.h"
#import "IndianaShopModel.h"
@interface IndianaShopDetailsOneCell ()
@property(nonatomic,strong)    SDCycleScrollView *cycleScrollViewImage;
@property (weak, nonatomic) IBOutlet UIView *ShufflingImgView;
@property (weak, nonatomic) IBOutlet UILabel *StatesLabel;
@end
@implementation IndianaShopDetailsOneCell
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
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
//    self.StatesLabel.layer.masksToBounds = YES;
//    self.StatesLabel.layer.cornerRadius = 5;
//    self.StatesLabel.layer.borderWidth = 0.8;
//    self.StatesLabel.layer.borderColor = [UIColor redColor].CGColor;
    [self.StatesLabel.layer setLaberMasksToBounds:YES cornerRadius:5 borderWidth:0.8 borderColor:[UIColor redColor]];
    self.progressV.userInteractionEnabled = NO;
    self.progressV.progress = 0.8;
    self.progressV.gradientColors = @[[UIColor colorWithHexString:@"#ffad45"],[UIColor colorWithHexString:kRedColor]];
    self.progressV.edgeColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.progressV.bgColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self createView];
}
- (void)createView {
    // 网络加载图片的轮播器
    if (!_cycleScrollViewImage) {
        self. cycleScrollViewImage = [SDCycleScrollView   cycleScrollViewWithFrame:CGRectMake(0, 0, Width, Width) delegate:self placeholderImage:[UIImage imageNamed:@"正在加载中..."]];
        _cycleScrollViewImage.autoScrollTimeInterval =3.0;
        [self.ShufflingImgView addSubview:  _cycleScrollViewImage];
    }
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    cycleScrollView =_cycleScrollViewImage;
    self.  IndianaShopDetailsOneCellScrollViewImageBlock(index);
}
-(void)setModel:(IndianaShopModel *)model{
    if (!model) return;
    _model = model;
    if (self.cycleScrollViewImage) {
        self.cycleScrollViewImage.imageURLStringsGroup =_model.images;
    }
    ///1-进行中 ，2-已结束 , 3-作废
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"进行中";
    }else if ([model.status isEqualToString:@"2"]){
        self.status.text = @"已结束";
    }else if ([model.status isEqualToString:@"3"]){
        self.status.text = @"已作废";
    }
    
    self.goods_name.text =[NSString stringWithFormat:@"                %@", _model.goods_name];
    self.times_no.text =[NSString stringWithFormat:@"期号:第%@期", _model.times_no];
    _players.text = [NSString stringWithFormat:@"已购买:%@",model.players];
     _counts.text = [NSString stringWithFormat:@"总需:%@",model.counts];
    _remaining.text = [NSString stringWithFormat:@"剩余:%d",[model.counts intValue]-[model.players intValue]
];

    self.progressV.progress =[_model.schedule floatValue]/100 ;
    
    
    
    
}
@end

