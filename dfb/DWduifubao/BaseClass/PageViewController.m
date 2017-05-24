//
//  PageViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PageViewController.h"
#import "MyPageController.h"
@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MyPageController * MYVC = [[MyPageController alloc]initWithNibName:@"MyPageController" bundle:nil] ;
    MYVC.view.frame = self.view.frame;
    [self addChildViewController:MYVC];
    
    [self.view addSubview:MYVC.view];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
