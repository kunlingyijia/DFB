//
//  SubmitOrderHeaderView.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "SubmitOrderHeaderView.h"
#import "HeaderModel.h"
@implementation SubmitOrderHeaderView
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
        
    }
    return self;
}
-(void)addSubviews{
    
    self.merchant_name = [[UILabel alloc]initWithFrame:CGRectMake(10, 0,(Width-20), Width/10)];
     _merchant_name.text = @"店名";
    _merchant_name.font = [UIFont systemFontOfSize:14];
    
    //_merchant_name.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_merchant_name];
    
    
}
-(void)cellGetData:(HeaderModel*)model{
        _merchant_name.text = model.merchant_name;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
