//
//  AgentModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgentModel : NSObject
///状态：1-待审核，2-审核通过，3-审核失败
@property (nonatomic, strong) NSString *status ;
///备注
@property (nonatomic, strong) NSString *remark ;
///	代理区域
@property (nonatomic, strong) NSString *region_name ;
///申请时间
@property (nonatomic, strong) NSString *create_time ;
///识别Id
@property (nonatomic, strong) NSString *ID ;


@end
