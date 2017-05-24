//
//  HomePageHeader.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "HomePageHeader.h"

@implementation HomePageHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * RedView= [[UIView alloc]initWithFrame:CGRectMake(10, (frame.size.height-20)/2, 3, 20)];
        RedView.backgroundColor = [UIColor redColor];
        [self addSubview:RedView];
        self.HeaderTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(RedView.frame)+5, (frame.size.height-20)/2, 200, 20)];
        _HeaderTitle.font = [UIFont systemFontOfSize:16];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 39.7, Width, 0.3)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        [self addSubview:_HeaderTitle];
        
    }
    return self;
}
@end
