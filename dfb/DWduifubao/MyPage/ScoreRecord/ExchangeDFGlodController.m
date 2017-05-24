//
//  ExchangeDFGlodController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ExchangeDFGlodController.h"

@interface ExchangeDFGlodController ()

@end

@implementation ExchangeDFGlodController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"兑换兑富金币";
    [self endEditingAction:self.view];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
}

//"兑换"的按钮事件
- (IBAction)exchangeBtnAction:(id)sender {
    [self showToast:@"兑换成功"];
}
@end
