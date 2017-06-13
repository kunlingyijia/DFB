//
//  IndianaShopModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class imageModel;
@class last_timeModel;
@interface IndianaShopModel : NSObject
///商品id
@property (nonatomic, strong) NSString  *goods_id ;
///	商品名称
@property (nonatomic, strong) NSString  *goods_name ;
///Logo图片
@property (nonatomic, strong) NSString  *goods_image ;
///相册图片
@property (nonatomic, strong) NSMutableArray <imageModel *> *images ;
/// 总需要人数
@property (nonatomic, strong) NSString  *counts ;
///参与人数
@property (nonatomic, strong) NSString  * players;
///期号
@property (nonatomic, strong) NSString  *times_no ;
///期id
@property (nonatomic, strong) NSString  *times_id ;
///1-进行中 ，2-已结束 , 3-作废 	状态1-待揭晓/未抢中，2-已中奖
@property (nonatomic, strong) NSString  *status ;
///开始时间
@property (nonatomic, strong) NSString  *start_time ;
///中奖号码
@property (nonatomic, strong) NSString  *luck_no ;
///中奖者昵称
@property (nonatomic, strong) NSString  *nick_name ;
///揭晓时间
@property (nonatomic, strong) NSString  *open_time ;
///百分比
@property (nonatomic, strong) NSString  *sort ;
///分类图片
@property (nonatomic, strong) NSString  *icon_url ;
///分类名称
@property (nonatomic, strong) NSString  *category_name ;
///进度
@property (nonatomic, strong) NSString  *schedule ;

///总需
@property (nonatomic, strong) NSString  *times_counts ;

///公司声明
@property (nonatomic, strong) NSString  *announce ;

///商品图文详情
@property (nonatomic, strong) NSString  *goods_content ;

///参与人次
@property (nonatomic, strong) NSString  *number ;


///是否评价 0-否 1-是
@property (nonatomic, strong) NSString  *is_comment ;
///剩余时间倒计时（秒）
@property (nonatomic, strong) NSString  *time_stamp_down ;










@end
