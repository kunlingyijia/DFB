//
//  CarModel.h
//  京东购物车
//
//  Created by 席亚坤 on 16/12/21.
//  Copyright © 2016年 席亚坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarModel : NSObject
///购物车id
@property (nonatomic, strong) NSString  *cart_id ;
/////数量
//@property (nonatomic, strong) NSString  *shu;
/////选择状态
//@property (nonatomic, strong) NSString  *chose;
///价格
@property (nonatomic, strong) NSString  * price;



///商品logo
@property (nonatomic, strong) NSString  *goods_logo ;
///商品名称
@property (nonatomic, strong) NSString  *goods_name ;

///规格id
@property (nonatomic, strong) NSString  *goods_spec_id ;


///选择规格
@property (nonatomic, strong) NSString  *goods_spec_name ;

///商品选择（0）
@property (nonatomic, strong) NSString  *goods_select ;


///商品id
@property (nonatomic, strong) NSString  *goods_id ;

///商品数量
@property (nonatomic, strong) NSString  *number ;
///店家id
@property (nonatomic, strong) NSString  *merchant_id ;
///商家名称
@property (nonatomic, strong) NSString  *merchant_name
 ;
///备注
@property (nonatomic, strong) NSString  *remark ;
///价格乘积
@property (nonatomic, strong) NSString  *Allprice ;
///数量
@property (nonatomic, strong) NSString  *num ;

///是否关注
@property (nonatomic, strong) NSString  *is_collect;
///是否评论
@property (nonatomic, strong) NSString  *is_comment ;

///运费
@property (nonatomic, strong) NSString  *total_freight ;

///order_goods_id

@property (nonatomic, strong) NSString  *order_goods_id
 ;





@end
