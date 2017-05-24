//
//  HVModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/25.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BaseViewController;
@interface HVModel : NSObject
///版本跟新
-(void)updateVerison;
///定位
-(void)AMap;
///关于手势和网络判断
-(void)gestrueViewAndInterView;
///控制器
@property (nonatomic, strong) BaseViewController  *HomeVC ;


@end
