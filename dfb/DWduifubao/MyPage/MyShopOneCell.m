//
//  MyShopOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MyShopOneCell.h"
#import "MyShopModel.h"
@implementation MyShopOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 5.0;
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    _oneView.clipsToBounds = YES;
    _twoView.clipsToBounds = YES;

}
-(void)CellGetData:(MyShopModel*)model{
    [DWHelper SD_WebImage:self.merchant_logo imageUrlStr:model.merchant_logo placeholderImage:@"敬请期待long"];
    [DWHelper SD_WebImage:_main_image imageUrlStr:model.main_image placeholderImage:@"敬请期待long"];
    if ([model.is_collect isEqualToString:@"1"]) {
        //关注
        self.GuanZhuImageView.image = [UIImage imageNamed:@"已关注"];
        self.GuanZhuLabel.text = @"已关注";
        self.GuanZhuLabel.textColor = [UIColor redColor];
    }else{
        self.GuanZhuImageView.image = [UIImage imageNamed:@"未关注"];
        self.GuanZhuLabel.text = @"未关注";
        self.GuanZhuLabel.textColor = [UIColor blackColor];
    }
    self.merchant_name.text = model.merchant_name;
    self.collect_peoples.text = [NSString stringWithFormat:@"%@ 人",model.collect_peoples];
   
}
- (IBAction)GuanZhuAction:(UIButton *)sender {
    self.cell();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
