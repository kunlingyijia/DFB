//
//  DWToastTool.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "DWToastTool.h"
#import "UIView+Toast.h"
@implementation DWToastTool
+(void)showToast:(NSString *)text{
    
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    [[UIApplication sharedApplication].keyWindow makeToast:text duration:2 position:CSToastPositionCenter];
}
@end
