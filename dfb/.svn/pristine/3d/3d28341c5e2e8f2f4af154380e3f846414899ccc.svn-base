//
//  DWCommonParm.m
//  DWduifubao
//
//  Created by kkk on 16/9/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWCommonParm.h"

@implementation DWCommonParm

+ (instancetype)sharedInstance {
    static DWCommonParm *conmonParm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conmonParm = [[DWCommonParm alloc] init];
    });
    return conmonParm;
}




@end
