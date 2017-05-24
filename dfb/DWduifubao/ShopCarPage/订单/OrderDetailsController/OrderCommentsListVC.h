//
//  OrderCommentsListVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/5.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderCommentsListVC : BaseViewController
///属性传值---订单商品
@property (nonatomic, strong) NSMutableArray  *goodsArray ;
///属性传值-订单号
@property (nonatomic, strong) NSString  *order_no ;



@end
