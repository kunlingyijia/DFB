//
//  RequestHeaderModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/17.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHeaderModel : NSObject
///纬度
@property (nonatomic, assign) CGFloat lat;
///经度
@property (nonatomic, assign) CGFloat lng;
///省
@property (nonatomic, strong) NSString *province ;
///市
@property (nonatomic, strong) NSString *city ;
///区县
@property (nonatomic, strong) NSString  *area ;
///地址
@property (nonatomic, strong) NSString *address ;
///客户端版本号
@property (nonatomic, strong) NSString  *appVersion ;
///1-iOS 2-Android  3-web
@property (nonatomic, strong) NSString  *clientOS ;
///设备号
@property (nonatomic, strong) NSString  *deviceNo ;
///系统版本
@property (nonatomic, strong) NSString  *systemVersion ;
///小米，iphone 4，iohone4s
@property (nonatomic, strong) NSString  *phoneModel ;

















@end
