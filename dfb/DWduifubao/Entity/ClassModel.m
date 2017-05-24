//
//  ClassModel.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
+ (instancetype)appWithDic:(NSDictionary*)dict
{
  ClassModel  * classModel = [[self alloc] init];
    [classModel setValuesForKeysWithDictionary:dict];
    
    return classModel;
}

@end
