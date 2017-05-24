//
//  AddressModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
///地址id
@property (nonatomic, strong) NSString *address_id ;

///收货人姓名
@property (nonatomic, strong) NSString *name ;

///	收货人电话号码

@property (nonatomic, strong) NSString *mobile ;

///邮政编码
@property (nonatomic, strong) NSString *postcode ;

///省市区
@property (nonatomic, strong) NSString *zone ;
///详细地址
@property (nonatomic, strong) NSString *address ;


///默认地值 0-否，1-是
@property (nonatomic, strong) NSString *is_default ;



@end
