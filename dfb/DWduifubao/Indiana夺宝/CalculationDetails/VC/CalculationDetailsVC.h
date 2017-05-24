//
//  CalculationDetailsVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class last_timeModel;
@interface CalculationDetailsVC : BaseViewController
@property (nonatomic, copy) void(^CalculationDetailsVCBlock)();

///model
@property (nonatomic, strong) last_timeModel *lasttimeModel ;

@end
