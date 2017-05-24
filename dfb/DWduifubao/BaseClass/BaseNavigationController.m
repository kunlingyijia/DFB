//
//  BaseNavigationController.m
//  DWduifubao
//
//  Created by kkk on 16/9/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()
@property(nonatomic,strong)UIView * interView;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitilColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
       
}
- (void)setTitilColor{
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithHexString:kTitleColor] forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
}

//设置只有一级界面显示Tabbar
- (void)pushViewController:(BaseViewController *)viewController animated:(BOOL)animated{
    if (viewController == [DWCommonParm sharedInstance].homePageController || viewController == [DWCommonParm sharedInstance].classPageController || viewController == [DWCommonParm sharedInstance].shopPageController|| viewController == [DWCommonParm sharedInstance].myPageController) {
        [viewController setHidesBottomBarWhenPushed:NO];
    }else{
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
    
}


@end
