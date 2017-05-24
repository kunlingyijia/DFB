//
//  MerchantsHomePageVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface MerchantsHomePageVC : BaseViewController
///
@property (nonatomic, copy) void(^MerchantsHomePageVCBlock)() ;

///merchant_id
@property (nonatomic, strong) NSString  *merchant_id ;


@end
