//
//  IndustryModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/2.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndustryModel : NSObject
///行业id
@property (nonatomic, strong) NSString *industry_id ;
///父级id
@property (nonatomic, strong) NSString *parent_id ;
///名称
@property (nonatomic, strong) NSString *name ;
///级别
@property (nonatomic, strong) NSString *level ;
///_child数组
@property (nonatomic, strong) NSMutableArray  *_child ;







@end
