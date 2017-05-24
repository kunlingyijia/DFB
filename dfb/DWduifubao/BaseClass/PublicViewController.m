//
//  PublicViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PublicViewController.h"

@interface PublicViewController ()
@property (weak, nonatomic) IBOutlet UIView *Views;

@end

@implementation PublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"敬请期待" ;
     self.Views.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
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
