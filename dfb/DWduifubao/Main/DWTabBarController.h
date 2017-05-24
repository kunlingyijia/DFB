//
//  DWTabBarController.h
//  DWduifubao
//
//  Created by kkk on 16/9/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomePageVC;
@class ClassMainViewController;
@class MyPageController;
@class ShopCarController;
@interface DWTabBarController : UITabBarController
@property (nonatomic, strong) HomePageVC *homePageController;
@property (nonatomic, strong) ClassMainViewController *classPageController;
@property (nonatomic, strong) ShopCarController  *shopCarController ;
@property (nonatomic, strong) MyPageController *myPageController;

@end
