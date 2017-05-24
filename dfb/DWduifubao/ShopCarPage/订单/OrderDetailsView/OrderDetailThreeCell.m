//
//  OrderDetailThreeCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderDetailThreeCell.h"
#import "CarModel.h"
@implementation OrderDetailThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(CarModel*)model{
    
    [DWHelper SD_WebImage:_goods_logo imageUrlStr:model.goods_logo placeholderImage:nil];
    _goods_name.text =  model.goods_name;
    _goods_spec_name.text =model.goods_spec_name;
    _number.text = [NSString stringWithFormat:@"X %@",model.num];
    _price.text = model.price;
    
    
}

@end
