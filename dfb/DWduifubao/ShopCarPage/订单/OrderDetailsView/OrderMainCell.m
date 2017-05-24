//
//  OrderMainCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "OrderMainCell.h"
#import "PublicBtn.h"
#import "GoodsModel.h"
@implementation OrderMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(GoodsModel*)model{
    [DWHelper SD_WebImage:_goods_logo imageUrlStr:model.goods_logo placeholderImage:nil];
    _goods_name.text = model.goods_name;
    _name.text = model.goods_spec_name;

    
}
@end
