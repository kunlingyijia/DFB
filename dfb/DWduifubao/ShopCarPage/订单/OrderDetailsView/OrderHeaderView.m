//
//  OrderHeaderView.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/5.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderHeaderView.h"
#import "OrderModel.h"
@implementation OrderHeaderView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=  [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}
-(void)addSubviews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 10)];
    view.backgroundColor =    [UIColor colorWithHexString:kViewBackgroundColor];
    [self.contentView addSubview:view];
    self.merchant_name = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view.frame),(Width-30)/3*2, Width/10)];
   // _merchant_name.text = @"店名";
    _merchant_name.font = [UIFont systemFontOfSize:14];
    _merchant_name.textColor = [UIColor grayColor];
    self.status=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_merchant_name.frame), CGRectGetMaxY(view.frame), (Width-30)/3*1,  Width/10)];
    //_status.text = @"状态";
     _status.font = [UIFont systemFontOfSize:14];
    _status.textAlignment =NSTextAlignmentRight;
    _status.textColor = [UIColor redColor];
    [self.contentView addSubview:_merchant_name];
    [self.contentView addSubview:_status];
    
    
}

-(void)cellGetData:(OrderModel*)model{
   // status	1	int	1-待付款 2-待发货  3-已发货  ,4-待评价，5-已完成
    if ([model.status isEqualToString:@"1"]) {
        _status.text = @"待付款";

    }else if ([model.status isEqualToString:@"2"]) {
        _status.text = @"待发货";
        
    }else if ([model.status isEqualToString:@"3"]) {
        _status.text = @"已发货";
        
    }else if ([model.status isEqualToString:@"4"]) {
        _status.text = @"待评价";
        
    }else if ([model.status isEqualToString:@"5"]) {
        _status.text = @"已完成";
        
    }
    
    _merchant_name.text = model.merchant_name;
}

@end
