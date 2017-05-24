//
//  HomeThreeCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "HomeThreeCell.h"
#import "GoodsModel.h"
@implementation HomeThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)cellGetData:(GoodsModel*)model{
    [DWHelper SD_WebImage:_goods_logo imageUrlStr:model.goods_logo placeholderImage:nil];
    _goods_name.text = model.goods_name;
    _price.text = model.price;
    _spec.text = model.spec_name;
}
@end
