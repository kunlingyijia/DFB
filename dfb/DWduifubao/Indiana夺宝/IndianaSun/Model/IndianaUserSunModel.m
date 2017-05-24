//
//  IndianaUserSunModel.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaUserSunModel.h"
#import "imageModel.h"
@implementation IndianaUserSunModel
//#把数组里面带有对象的类型专门按照这个方法，这个格式写出来
-(nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"images" : imageModel.class,
             };
}
@end
