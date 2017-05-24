//
//  CALayer+LayerColor.h
//  DWduifubao
//
//  Created by kkk on 16/9/18.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (LayerColor)

 - (void)setBorderColorFromUIColor:(UIColor *)color;
-(void)setLaberMasksToBounds:(BOOL)masksToBounds cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;
@end
