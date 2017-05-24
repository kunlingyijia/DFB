//
//  GoodsHomeOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoodsHomeOneCell.h"
#import "GoodsModel.h"
@implementation GoodsHomeOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)cellGetData:(GoodsModel*)model{
    _goods_name.text = model.goods_name;
    _name.text =[NSString stringWithFormat:@"已选: %@ , %@个",model.name, model.number];;
    //_number.text =[NSString stringWithFormat:@"已选:%@个", model.number];
    _price.text = [NSString stringWithFormat:@"兑富币 %@", model.price];
    _total_freight.text =[NSString stringWithFormat:@"运费 %@", model.freight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
