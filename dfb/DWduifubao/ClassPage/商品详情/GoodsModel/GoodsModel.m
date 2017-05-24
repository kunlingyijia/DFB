//
//  GoodsModel.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "GoodsModel.h"
#import "imagesModel.h"
#import "specModel.h"
@implementation GoodsModel
//#把数组里面带有对象的类型专门按照这个方法，这个格式写出来
-(nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"spec" : specModel.class,@"images" : imagesModel.class
             };
}

@end
