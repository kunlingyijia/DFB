//
//  IndianaUserSunModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class imageModel;
@interface IndianaUserSunModel : NSObject
///相册图片
@property (nonatomic, strong) NSMutableArray <imageModel *> *images ;
///用户id
@property (nonatomic, strong) NSString  *user_id ;
///购买数量/参入次数
@property (nonatomic, strong) NSString  *number ;
///Ip
@property (nonatomic, strong) NSString  *ip ;
///参与 时间//create_time
@property (nonatomic, strong) NSString  *create_time ;
///用户昵称
@property (nonatomic, strong) NSString  *nick_name ;
///用户头像
@property (nonatomic, strong) NSString  *avatar_url ;
///期号
@property (nonatomic, strong) NSString  *times_no ;
///评论内容
@property (nonatomic, strong) NSString  *content ;
///商品id
@property (nonatomic, strong) NSString  *goods_id ;
///期id
@property (nonatomic, strong) NSString  *times_id ;
///联系电话
@property (nonatomic, strong) NSString  *tel ;
///实际支付的兑富币
@property (nonatomic, strong) NSString  *pay_amount ;
///商品名称
@property (nonatomic, strong) NSString  *goods_name ;
///图片
@property (nonatomic, strong) NSString  *goods_image ;

///状态
@property (nonatomic, strong) NSString  *status ;
///手势密码
@property (nonatomic, strong) NSString  *pay_password ;
///揭晓时间
@property (nonatomic, strong) NSString  *open_time ;
///姓名
@property (nonatomic, strong) NSString  *name ;
///幸运号
@property (nonatomic, strong) NSString  *luck_no ;
///是否评价 0-否 1-是

@property (nonatomic, strong) NSString  *is_comment ;

///	总需
@property (nonatomic, strong) NSString  *counts ;


///order_no
@property (nonatomic, strong) NSString  *order_no ;

///用户id
@property (nonatomic, strong) NSString  *win_user_id	 ;



@property (nonatomic,assign)CGFloat  CellHeight;





@end
