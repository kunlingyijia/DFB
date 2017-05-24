//
//  PerfectinformationViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/2.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PerfectinformationViewController.h"
#import "PerfectDataController.h"
@interface PerfectinformationViewController ()

@end

@implementation PerfectinformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showBackBtn];
    self.title = @"升级成功";
    // 1. 配值数据源对象
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"夺宝-箭头-左.png"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
#pragma mark ----- 屏幕边缘平移手势
    
    //屏幕边缘移动手势
    //创建屏幕边缘平移手势
    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(doBack:)];
    
    //设置平移的屏幕边界
    
    screenEdgePanGesture.edges = UIRectEdgeLeft;
    //添加到视图
    
    [self.view addGestureRecognizer:screenEdgePanGesture];}

- (void)doBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 完善资料
- (IBAction)wanshanZiliao:(UIButton *)sender {
    //Push 跳转
    PerfectDataController * VC = [[PerfectDataController alloc]initWithNibName:@"PerfectDataController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

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
