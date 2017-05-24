//
//  AuditViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/31.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AuditViewController.h"

@interface AuditViewController ()

@end

@implementation AuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self showBackBtn];
        self.title = self.titleStr;
     [self.navigationController setNavigationBarHidden:NO animated:YES];
   // [self endEditingAction:self.view];
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

#pragma mark ----- 屏幕边缘平移手势
    
    //屏幕边缘移动手势
    //创建屏幕边缘平移手势
    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(doBack:)];
    
    //设置平移的屏幕边界
    
    screenEdgePanGesture.edges = UIRectEdgeLeft;
    //添加到视图
    
    [self.view addGestureRecognizer:screenEdgePanGesture];

}

- (void)doBack:(id)sender{
    [BackgroundService requestPushVC:self MyselfAction:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
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
