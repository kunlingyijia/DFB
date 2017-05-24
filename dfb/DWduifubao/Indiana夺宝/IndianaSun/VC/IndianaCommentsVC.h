//
//  IndianaCommentsVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class IndianaUserSunModel ;
@interface IndianaCommentsVC : BaseViewController
@property (nonatomic, copy) void(^IndianaCommentsVCBlock)();
///IndianaUserSunModel
@property (nonatomic, strong) IndianaUserSunModel   *UserSunModel  ;
@end
