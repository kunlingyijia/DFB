//
//  collectionTwoCell.m
//  改变布局--集合视图
//
//  Created by 席亚坤 on 16/11/21.
//  Copyright © 2016年 席亚坤. All rights reserved.
//

#import "collectionTwoCell.h"
#import "GoodsModel.h"
@implementation collectionTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)cellGetData:(GoodsModel*)model{
    [DWHelper SD_WebImage:_goods_logo imageUrlStr:model.goods_logo   placeholderImage:nil];
    _goods_name.text = model.goods_name;
    _price.text = model.price;
    _comment_num.text = [NSString stringWithFormat:@"%@人评论",model.comment_num];
    _sales_num.text = [NSString stringWithFormat:@"%@人付款",model.sales_num];
}
@end
