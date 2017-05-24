//
//  specModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface specModel : NSObject
///商品id
@property (nonatomic, strong) NSString  *goods_id;
///规格id
@property (nonatomic, strong) NSString  *goods_spec_id;
///规格名称
@property (nonatomic, strong) NSString  *name;
///价格
@property (nonatomic, strong) NSString  *price;
///库存
@property (nonatomic, strong) NSString  *stock;
///运费
@property (nonatomic, strong) NSString  *total_freight ;






@end
