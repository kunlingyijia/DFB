//
//  UIImageView+SD.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "UIImageView+SD.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SD)
///图片展示
-(void)SD_WebimageUrlStr:(NSString*)urlStr placeholderImage:(NSString*)placeholder{
    
    if (placeholder==nil) {
        [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"敬请期待"]];
    }else{
        if (![urlStr isKindOfClass:[NSNull class]]) {
            [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",placeholder]]];
        }
        
    }
    
}

@end
