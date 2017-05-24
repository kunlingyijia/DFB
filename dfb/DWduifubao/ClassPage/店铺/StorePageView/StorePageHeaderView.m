//
//  StorePageHeaderView.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "StorePageHeaderView.h"
#import "MyShopModel.h"
@implementation StorePageHeaderView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       //        for (id tempView in _bottomView.subviews) {
//            NSLog(@"++++++++%@",tempView);
//            if([tempView isKindOfClass:[UIView class]]){
//                UIView *view = tempView;
//                 view.clipsToBounds = YES;
//            }
//        }
       
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 5.0;
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    _oneView.clipsToBounds = YES;
    _twoView.clipsToBounds = YES;
   
}
-(void)layoutSubviews{
    CGRect Frame ;
    Frame = CGRectMake(0, 0, Width, 0.4*Width);
    self.frame = Frame;
}
-(void)cellGetData:(MyShopModel*)model{
    NSLog(@"-----%@",model.is_collect);
    if ([model.is_collect isEqualToString:@"0"]) {
        //未关注
        self.GuanZhuLabel.text = @"关注";
        self.GuanZhuImageView.image = IMG_Name(@"未关注");
    }else if ([model.is_collect isEqualToString:@"1"]){
        self.GuanZhuLabel.text = @"已关注";
        self.GuanZhuImageView.image = IMG_Name(@"已关注");
    }
    _collect_peoples.text =[NSString stringWithFormat:@"%@ 人", model.collect_peoples];
    [DWHelper SD_WebImage:_merchant_logo imageUrlStr:model.merchant_logo placeholderImage:@"敬请期待long"];
    [DWHelper SD_WebImage:_main_image imageUrlStr:model.main_image placeholderImage:@"敬请期待long"];
    _merchant_name.text = model.merchant_name;
}
@end
