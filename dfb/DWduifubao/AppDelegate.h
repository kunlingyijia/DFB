//
//  AppDelegate.h
//  DWduifubao
//
//  Created by kkk on 16/9/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GesturePasswordView;
static NSString *appKey = JGKey;
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)GesturePasswordView * gestureView;
@end

