//
//  ScoreExchangeController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ScoreExchangeController.h"
#import "ExchangeDFGlodController.h"
#import "ExchangeDFBaoController.h"
#import "ExchangeGoldVC.h"
@interface ScoreExchangeController ()

@end

@implementation ScoreExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"兑换";
    [self addViewTargetAction];
    //获取个人信息
    [BackgroundService requestPushVC:nil MyselfAction:^{
                
    }];
}

//为View添加点击事件
- (void)addViewTargetAction {
    //"兑换兑富金币"
    UITapGestureRecognizer *exchangeDFGlodViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeDFGlodViewAction:)];
    [self.exchangeDFGlodView addGestureRecognizer:exchangeDFGlodViewTap];
    //"兑换兑富金币+兑富宝"
    UITapGestureRecognizer *exchangeDFBaoViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeDFBaoViewAction:)];
    [self.exchangeDFBaoView addGestureRecognizer:exchangeDFBaoViewTap];
}

//"兑换兑富金币"的View事件
- (void)exchangeDFGlodViewAction:(UITapGestureRecognizer *)sender {
    ExchangeGoldVC * VC = [[ExchangeGoldVC alloc]initWithNibName:@"ExchangeGoldVC" bundle:nil];
    NSString * str =[AuthenticationModel getvirtual_glod];
    VC.virtual_glodAndcash =[[AuthenticationModel getcash] floatValue];    //[self.virtual_glodAndcashLabel.text floatValue];
    [self.navigationController  pushViewController:VC animated:YES];
}

//"兑换兑富金币+兑富宝"的View事件
- (void)exchangeDFBaoViewAction:(UITapGestureRecognizer *)sender {
    ExchangeDFBaoController *exchangeDFBaoController = [[ExchangeDFBaoController alloc] initWithNibName:@"ExchangeDFBaoController" bundle:nil];
    exchangeDFBaoController.scoreAll = self.scoreAll;
    [self.navigationController pushViewController:exchangeDFBaoController animated:YES];
}
@end
