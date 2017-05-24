//
//  AddressManageController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class AddressModel;
typedef void (^AddressVC)(AddressModel *model);
@interface AddressManageController : BaseViewController
@property(nonatomic,copy)AddressVC addressVC;
-(void)AddressVCReturn:(AddressVC)addressVC;
@end
