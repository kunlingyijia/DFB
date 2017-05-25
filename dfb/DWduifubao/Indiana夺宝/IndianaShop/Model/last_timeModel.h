//
//  last_timeModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/15.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface last_timeModel : NSObject

///[上期揭晓]获奖者
@property (nonatomic, strong) NSString  *win_name ;
///[上期揭晓]中奖号码
@property (nonatomic, strong) NSString  *luck_no ;
///[上期揭晓]期号
@property (nonatomic, strong) NSString  *times_no ;
///期id
@property (nonatomic, strong) NSString  *times_id ;
///[上期揭晓]揭晓时间
@property (nonatomic, strong) NSString  *open_time ;
///[上期揭晓]头像
@property (nonatomic, strong) NSString  *avatar_url;
///参与分数
@property (nonatomic, strong) NSString  *number ;

///[上期揭晓]计算详情
@property (nonatomic, strong) NSString  *computing_result ;






@end
