//
//  StoreListCellCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "StoreListCellCell.h"
#import "MyShopModel.h"
@implementation StoreListCellCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.merchant_logo.layer.borderColor = [UIColor whiteColor].CGColor ;
    self.merchant_logo.layer.masksToBounds = YES;
    self.merchant_logo.layer.cornerRadius = 5;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(MyShopModel*)model{
    self.merchant_name.text = model.merchant_name;
    self.collect_peoples.text =[NSString stringWithFormat:@" %@人关注", model.collect_peoples];
    [DWHelper SD_WebImage:self.merchant_logo imageUrlStr:model.merchant_logo placeholderImage:nil];
    
}
@end
