//
//  HeaderCarView.m
//  京东购物车
//
//  Created by 席亚坤 on 16/11/22.
//  Copyright © 2016年 席亚坤. All rights reserved.
//

#import "HeaderCarView.h"
#import "HeaderModel.h"
#import "PublicBtn.h"
@implementation HeaderCarView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
   self=  [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}
-(void)addSubviews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 10)];
    view.backgroundColor =    [UIColor colorWithHexString:kViewBackgroundColor];
    [self.contentView addSubview:view];
    
    self.oneBtn = [PublicBtn buttonWithType:(UIButtonTypeCustom)];
    
    _oneBtn.frame = CGRectMake(0, CGRectGetMaxY(view.frame), 40, 40);
    [_oneBtn setImage:[UIImage imageNamed:@"购物车-未选中"] forState:(UIControlStateNormal)];
    //_oneBtn.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_oneBtn];
    self.twoBtn = [PublicBtn buttonWithType:(UIButtonTypeSystem)];
    _twoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _twoBtn.frame = CGRectMake(CGRectGetMaxX(_oneBtn.frame)+10, CGRectGetMaxY(view.frame)+10, 200, 20);
    [_twoBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [self.contentView addSubview:_twoBtn];

}
-(void)headerGetData:(HeaderModel*)model{
    if ([model.merchant_select isEqualToString:@"1"]) {
        [self.oneBtn setImage:[UIImage imageNamed:@"购物车-选中打钩"] forState:(UIControlStateNormal)];
    }else{
        [self.oneBtn setImage:[UIImage imageNamed:@"购物车-未选中"] forState:(UIControlStateNormal)];
        
    }
    [_twoBtn setTitle:model.merchant_name forState:(UIControlStateNormal)];
}
@end
