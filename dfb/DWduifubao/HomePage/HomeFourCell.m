//
//  HomeFourCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "HomeFourCell.h"
#import "MyShopModel.h"

@implementation HomeFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.JinDianBut.layer.borderWidth = 0.5;
    self.JinDianBut.layer.borderColor = [UIColor redColor].CGColor ;
    self.JinDianBut.layer.masksToBounds = YES;
    self.JinDianBut.layer.cornerRadius = 5;
    self.JinDianBut.layer.borderWidth = 0.5;
    self.merchant_logo.layer.borderColor = [UIColor whiteColor].CGColor ;
    self.merchant_logo.layer.masksToBounds = YES;
    self.merchant_logo.layer.cornerRadius = 5;
    
    
}
//-(void)setModel:(MyShopModel *)model{
//    _model = model;
//    self.merchant_name.text = model.merchant_name;
//    [DWHelper SD_WebImage:self.merchant_logo imageUrlStr:model.merchant_logo placeholderImage:nil ];
//    self.address.text =model.content;
//    
//}
-(void)cellGetData:(MyShopModel*)model{
    self.merchant_name.text = model.merchant_name;
    [DWHelper SD_WebImage:self.merchant_logo imageUrlStr:model.merchant_logo placeholderImage:nil ];
    self.address.text =model.content;
    
}


@end
