//
//  PersonalCenterController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/11.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class PersonModel ;
@protocol PersonalCenterControllerDelegate <NSObject>

-(void)PersonalCenterControllerBack;
@end

@interface PersonalCenterController : BaseViewController
///
@property (nonatomic, assign) id<PersonalCenterControllerDelegate> delegate;
//属性传值
///PerSonModel
@property (nonatomic, strong) PersonModel *personModel ;



@end
