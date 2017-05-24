//
//  DWTabBarController.m
//  DWduifubao
//
//  Created by kkk on 16/9/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWTabBarController.h"
//#import "HomePageController.h"
#import "HomePageVC.h"

#import "ClassMainViewController.h"
#import "MyPageController.h"
//#import "ShopCarPageController.h"
#import "ShopCarController.h"
@interface DWTabBarController ()

@end

@implementation DWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addAllChidViewController];
}


- (void)addAllChidViewController {
    //tabbar的背景颜色
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    [self.tabBar insertSubview:bgView atIndex:0];
    bgView.userInteractionEnabled = YES;

    bgView.backgroundColor = [UIColor whiteColor];
    self.tabBar.opaque = YES;
    
    //创建主页面四个分类
    //创建一个单例 存储四个分类 在整个工程都能用
    self.homePageController = [[HomePageVC alloc] initWithNibName:@"HomePageVC" bundle:nil];
    self.classPageController = [[ClassMainViewController alloc] init];
   
    self.shopCarController = [[ShopCarController alloc] initWithNibName:@"ShopCarController" bundle:nil];
    self.myPageController = [[MyPageController alloc] initWithNibName:@"MyPageController" bundle:nil];
    
    [DWCommonParm sharedInstance].homePageController = self.homePageController;
    [DWCommonParm sharedInstance].classPageController = self.classPageController;
    [DWCommonParm sharedInstance].myPageController = self.myPageController;
    [DWCommonParm sharedInstance].shopPageController = self.shopCarController;
    //购物车 数量赋值
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0&& ![[AuthenticationModel getCarNumber]isEqualToString:@"0"]) {
         [DWCommonParm sharedInstance].shopPageController.tabBarItem.badgeValue = [[AuthenticationModel getCarNumber] intValue] >99 ? @"99+" : [AuthenticationModel getCarNumber];
    }

    [self addOneChildVc:self.homePageController title:@"首页" imageName:@"首页" selectedImageName:@"首页－点击"];
    [self addOneChildVc:self.classPageController title:@"分类" imageName:@"分类" selectedImageName:@"分类－点击"];
    [self addOneChildVc:self.shopCarController title:@"购物车" imageName:@"购物车" selectedImageName:@"购物车－点击"];
   [self addOneChildVc:self.myPageController title:@"我的" imageName:@"我的" selectedImageName:@"我的－点击"];
    
    //添加导航控制器
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:self.homePageController];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:self.classPageController];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:self.shopCarController];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] initWithRootViewController:self.myPageController];
    self.viewControllers = @[nav1, nav2, nav3, nav4];
    
    
}

- (void)addOneChildVc:(BaseViewController *)childVc title:(NSString *)title imageName:(NSString *)imageN selectedImageName:(NSString *)selectedImageN {
    //设置标题
    childVc.title = title;
    //设置图标
    childVc.tabBarItem.image = [[UIImage imageNamed:imageN] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置选中图标
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageN] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    //设置文字
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName, [UIColor colorWithHexString:kTitleColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName, [UIColor colorWithHexString:kRedColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //添加导航控制器
//    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childVc];
//    //把导航控制器放到tabbar上
//    [self addChildViewController:nav];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
