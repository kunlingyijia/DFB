//
//  HuiYuanModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuiYuanModel : NSObject
///is_today
@property (nonatomic, assign) NSInteger is_today;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;

///每页请求多少条
@property (nonatomic, assign) NSInteger pageCount;
///添加时间
@property (nonatomic, strong) NSString *create_time ;
///添加姓名
@property (nonatomic, strong) NSString *nick_name ;






@end
