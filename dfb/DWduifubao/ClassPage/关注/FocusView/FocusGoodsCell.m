//
//  FocusGoodsCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "FocusGoodsCell.h"
#import "GoodsModel.h"
@implementation FocusGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(GoodsModel*)model{
    [DWHelper SD_WebImage:_goods_logo imageUrlStr:model.goods_logo   placeholderImage:nil];
    _goods_name.text = model.goods_name;
    _price.text = model.price;
    _comment_num.text = [NSString stringWithFormat:@"%@人评论",model.comment_num];
    _sales_num.text = [NSString stringWithFormat:@"%@人付款",model.sales_num];

}
@end
