//
//  OrderFooterView.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/5.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderFooterView.h"
#import "OrderModel.h"
@implementation OrderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=  [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)addSubviews{
    
    _number = [[UILabel alloc]initWithFrame:CGRectMake(Width/3, 0, Width/3, Width/10)];
    _number.font = [UIFont systemFontOfSize:15];
    _number.textColor = [UIColor grayColor];
    [self.contentView addSubview:_number];
    
    _allPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_number.frame), 0, Width/3, Width/10)];
    _allPrice.font = [UIFont systemFontOfSize:15];
    _allPrice.textColor = [UIColor redColor];
    [self.contentView addSubview:_allPrice];

    self.oneBtn = [PublicBtn buttonWithType:(UIButtonTypeCustom)];
    _oneBtn.frame =CGRectMake(Width/2, CGRectGetMaxY(_number.frame)+ 5,(Width)/4-20, Width/10-10);
   
    self.twoBtn = [PublicBtn buttonWithType:(UIButtonTypeCustom)];
    _twoBtn.frame =CGRectMake(CGRectGetMaxX(_oneBtn.frame)+10, CGRectGetMaxY(_number.frame)+ 5,(Width)/4-20, Width/10-10);
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_twoBtn.frame)+10, Width, 0.3)];
//    [self.contentView addSubview:view];
//    view.backgroundColor = [UIColor lightGrayColor];
//    

    [self.contentView addSubview:_oneBtn];
    [self.contentView addSubview:_twoBtn];
    [_oneBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
     [_twoBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    self.oneBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.oneBtn.layer.borderWidth = 0.5;
    self.oneBtn.layer.masksToBounds = YES;
    self.oneBtn.layer.cornerRadius = 5;
    self.twoBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.twoBtn.layer.borderWidth = 0.5;
    self.twoBtn.layer.masksToBounds = YES;
    self.twoBtn.layer.cornerRadius = 5;
    self.twoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.oneBtn.titleLabel.font = [UIFont systemFontOfSize:14];

}

-(void)cellGetData:(OrderModel*)model{
    // status	1	int	1-待付款 2-待发货  3-已发货  ,4-待评价，5-已完成
        if ([model.status isEqualToString:@"1"]) {
           self.oneBtn.hidden = NO;
           self.twoBtn.hidden = NO;
           [self.oneBtn setTitle:@"取消订单" forState:(UIControlStateNormal)];
           [self.twoBtn setTitle:@"去付款" forState:(UIControlStateNormal)];
    }else if ([model.status isEqualToString:@"2"]) {
       
        self.oneBtn.hidden = YES;
        self.twoBtn.hidden = NO;
       // [self.oneBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.twoBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        
    }else if ([model.status isEqualToString:@"3"]) {
        self.oneBtn.hidden = NO;
        self.twoBtn.hidden = NO;
        [self.oneBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.twoBtn setTitle:@"确认收货" forState:(UIControlStateNormal)];
        
    }else if ([model.status isEqualToString:@"4"]) {
        self.oneBtn.hidden = NO;
        self.twoBtn.hidden = NO;
        [self.oneBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.twoBtn setTitle:@"去评价" forState:(UIControlStateNormal)];
        
    }else if ([model.status isEqualToString:@"5"]) {
        self.oneBtn.hidden = YES;
        self.twoBtn.hidden = NO;
        [self.oneBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.twoBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        
    }
    
   // _number.text = [NSString stringWithFormat:@"共%@件商品",model.number];
    _allPrice.text = [NSString stringWithFormat:@"兑富币: %@" ,model.amount];
}

@end
