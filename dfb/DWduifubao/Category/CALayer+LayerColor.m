//
//  CALayer+LayerColor.m
//  DWduifubao
//
//  Created by kkk on 16/9/18.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.masksToBounds = YES;
    self.borderColor = color.CGColor;
}
-(void)setLaberMasksToBounds:(BOOL)masksToBounds cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor{
    
    self.masksToBounds = YES;
    self.cornerRadius = cornerRadius;
    self.borderWidth = borderWidth;
    if (borderColor !=nil) {
        self.borderColor = borderColor.CGColor;
    }else{
       self.borderColor = [UIColor clearColor].CGColor;
    }
    
    
}
@end
