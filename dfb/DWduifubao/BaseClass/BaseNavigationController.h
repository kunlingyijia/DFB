//
//  BaseNavigationController.h
//  DWduifubao
//
//  Created by kkk on 16/9/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

- (void)pushViewController:(BaseViewController *)viewController animated:(BOOL)animated;

@end
