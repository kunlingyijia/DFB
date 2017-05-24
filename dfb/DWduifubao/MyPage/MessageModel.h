//
//  MessageModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

///标题
@property (nonatomic, strong) NSString *title ;
///内容
@property (nonatomic, strong) NSString *content ;
///时间
@property (nonatomic, strong) NSString *create_time ;

@end
