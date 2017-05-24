//
//  ClassModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
///表id
@property (nonatomic, assign) int category_id;
///分类名称
@property (nonatomic, strong) NSString *category_name ;
///上级id
@property (nonatomic, assign) int *parent_id ;
///等级
@property (nonatomic, assign) int *level ;
///是否热门分类
@property (nonatomic, assign) int is_hot;

///图片网址
@property (nonatomic, strong) NSString *image_url ;

+ (instancetype)appWithDic:(NSDictionary*)dict;




@end
