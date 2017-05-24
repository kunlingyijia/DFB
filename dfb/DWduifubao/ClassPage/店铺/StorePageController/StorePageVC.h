//
//  StorePageVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    //以下是枚举成员
    oneCellLayout,
    twoCellLayout
    
}CollocationCellLayout;//枚举名称

@interface StorePageVC : BaseViewController
///Cell布局类型
@property (nonatomic, assign) CollocationCellLayout  collocationCellLayout ;
///属性传值
///关键字
@property (nonatomic, strong) NSString  *keywords ;
///店铺Id
@property (nonatomic, strong) NSString  *merchant_id;
///分类id
@property (nonatomic, strong) NSString  *category_id ;
@end
