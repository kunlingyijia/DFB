//
//  GoodsModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class imagesModel;
@class specModel;
@interface GoodsModel : NSObject

///商品图片数组
@property (nonatomic, strong) NSArray <imagesModel *> *images ;
///商品规格数组
@property (nonatomic, strong) NSArray <specModel *> *spec ;

///商户id
@property (nonatomic, strong) NSString  *merchant_id ;
///商家名称
@property (nonatomic, strong) NSString  *merchant_name;


///商品Id
@property (nonatomic, strong) NSString  *goods_id ;
///商品名称
@property (nonatomic, strong) NSString  *goods_name ;
///商品logo
@property (nonatomic, strong) NSString  *goods_logo ;
///价格（兑富币）
@property (nonatomic, strong) NSString  *price ;
///规格（1条）
@property (nonatomic, strong) NSString  *spec_name ;
///类型：1-url ,2-商品, 3-商户
@property (nonatomic, strong) NSString  *type ;
///外部：链接
@property (nonatomic, strong) NSString  *web_url ;


///规格名称
@property (nonatomic, strong) NSString  *name ;
/////规格价格
//@property (nonatomic, strong) NSString  *price ;

///选择数量
@property (nonatomic, strong) NSString  *number ;

///规格id
@property (nonatomic, strong) NSString  *goods_spec_id ;
///选择规格
@property (nonatomic, strong) NSString  *goods_spec_name ;

///商品描述
@property (nonatomic, strong) NSString  *goods_content ;

///关注数量
@property (nonatomic, strong) NSString  *collect_peoples ;


///int	关键字(可选)
@property (nonatomic, strong) NSString  *keywords ;
///分类id(可选)
@property (nonatomic, strong) NSString  *category_id ;
///按金币(可选) 1 -推荐 0 -否
@property (nonatomic, strong) NSString  *gold_fit ;
///按销量排序（可选）1-升序 2-降序
@property (nonatomic, strong) NSString  *order_sales_num ;
///按价格排序（可选）1-升序 2-降序
@property (nonatomic, strong) NSString  *order_price ;

///	分页参数
@property (nonatomic, strong) NSString  *pageIndex ;
///每页请求多少条
@property (nonatomic, strong) NSString  *pageCount ;

///评论数量
@property (nonatomic, strong) NSString  *comment_num ;
///评价等级 1-好评 2-中评 3-差评
@property (nonatomic, strong) NSString  *rank ;

///1-待付款 2-待发货  3-已发货  ,4-待评价，5-已完成 6-全部
@property (nonatomic, strong) NSString  *status ;

///订单商品数
@property (nonatomic, strong) NSString  *num ;

///备注
@property (nonatomic, strong) NSString  *remark ;
/// //is_collect 是否关注0否/1是
@property (nonatomic, strong) NSString  *is_collect ;
///是否评论  0否/1是
@property (nonatomic, strong) NSString  *is_comment ;

///订单号
@property (nonatomic, strong) NSString  *order_no ;
///评论内容
@property (nonatomic, strong) NSString  *content ;
///销量
@property (nonatomic, strong) NSString  *sales_num ;

///订单商品id
@property (nonatomic, strong) NSString  *order_goods_id;

///运费
@property (nonatomic, strong) NSString  *freight ;

///活动图片(新版)
@property (nonatomic, strong) NSString  *activity_img;














@end
