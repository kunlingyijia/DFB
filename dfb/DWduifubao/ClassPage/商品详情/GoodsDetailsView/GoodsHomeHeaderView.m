//
//  GoodsHomeHeaderView.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoodsHomeHeaderView.h"

@implementation GoodsHomeHeaderView
-(void)layoutSubviews{
    CGRect  frame = self.frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
     frame.size.height = [UIScreen mainScreen].bounds.size.width;
    [self setFrame:frame];
    
   // self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
