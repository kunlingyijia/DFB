//
//  SubmitOrdersCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SubmitOrdersCell.h"
#import "CarModel.h"
@implementation SubmitOrdersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)cellGetData:(CarModel*)model{

    [DWHelper SD_WebImage:_goods_logo imageUrlStr:model.goods_logo placeholderImage:nil];
    _goods_name.text =  model.goods_name;
    _goods_spec_name.text =model.goods_spec_name;
    _number.text = [NSString stringWithFormat:@" x %@",model.number];
    _price.text = model.price;
    
    
}
@end
