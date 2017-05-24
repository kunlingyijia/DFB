//
//  OrderCommentsListCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/5.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderCommentsListCell.h"
#import "GoodsModel.h"
@implementation OrderCommentsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentsBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.commentsBtn.layer.borderWidth = 0.5;
    self.commentsBtn.layer.masksToBounds = YES;
    self.commentsBtn.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(GoodsModel*)model{
    
    NSLog(@"model.is_comment ---%@",model.is_comment );
    [DWHelper SD_WebImage:_goods_logo imageUrlStr:model.goods_logo placeholderImage:nil];
    _goods_name.text = model.goods_name;
    _name.text = model.goods_spec_name;
    if ([model.is_comment isEqualToString:@"0"]) {
        [_commentsBtn    setTitle:@"去评论" forState:(UIControlStateNormal)];
    }else if([model.is_comment isEqualToString:@"1"]){
       [_commentsBtn    setTitle:@"评论完成" forState:(UIControlStateNormal)];
    }
    //    _number.text =[NSString stringWithFormat:@"共%@件商品",model.number];
    //    _allPrice.text = @"记得修改我";
    
}

@end
