//
//  GoodsListViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsModel.h"

typedef enum {
    //以下是枚举成员
    oneCellLayoutList,
    twoCellLayoutList
    
    
}CollocationCellLayoutList;//枚举名称

@interface GoodsListViewController : BaseViewController
///Cell布局类型
@property (nonatomic, assign) CollocationCellLayoutList  collocationCellLayout ;
///属性传值
///关键字
@property (nonatomic, strong) NSString  *keywords ;
///店铺Id
@property (nonatomic, strong) NSString  *merchant_id;
///分类id
@property (nonatomic, strong) NSString  *category_id ;

///按金币(可选) 1 -推荐 0 -否
@property (nonatomic, strong) NSString  *gold_fit ;











@end

