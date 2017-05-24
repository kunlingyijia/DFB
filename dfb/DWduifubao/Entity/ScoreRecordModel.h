//
//  ScoreRecordModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreRecordModel : NSObject

///score_type
@property (nonatomic, assign) NSInteger score_type;
///积分
@property (nonatomic, assign) CGFloat amount;

///积分来自哪里
@property (nonatomic, strong) NSString *remark ;

///时间
@property (nonatomic, strong) NSString *create_time ;

///类型
@property (nonatomic, assign) NSInteger type;







@end
