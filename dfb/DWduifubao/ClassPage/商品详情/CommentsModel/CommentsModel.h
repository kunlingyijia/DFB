//
//  CommentsModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsModel : NSObject
///评论总数
@property (nonatomic, strong) NSString  *comment_num ;
///用户名称
@property (nonatomic, strong) NSString  *nick_name ;
///头像URL
@property (nonatomic, strong) NSString  *avatar_url ;
///评论内容
@property (nonatomic, strong) NSString  *content ;
///评价时间
@property (nonatomic, strong) NSString  *create_time ;
///评价等级 1-好评 2-中评 3-差评

@property (nonatomic, strong) NSString  *rank ;
///商品id
@property (nonatomic, strong) NSString  *goods_id ;

///分页参数
@property (nonatomic, strong) NSString*  pageIndex ;
///每页请求多少条
@property (nonatomic, strong) NSString* pageCount;

///订单号
@property (nonatomic, strong) NSString  *order_no ;
///订单商品id
@property (nonatomic, strong) NSString  *order_goods_id ;







@end
