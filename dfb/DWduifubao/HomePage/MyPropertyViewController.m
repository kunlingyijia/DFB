//
//  MyPropertyViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyPropertyViewController.h"
#import "MoneyViewController.h"
#import "ScoreRecordController.h"
#import "PublicViewController.h"
#import "LoginController.h"
#import "PersonModel.h"
#import "PayViewController.h"
#import "ScoreExchangeController.h"
#import "MessageViewController.h"
@interface MyPropertyViewController ()
@property (nonatomic, strong) PersonModel *personModel ;
@end

@implementation MyPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    [self ShowNodataView];
   

    self.title = @"我的资产";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.DuiHuan.layer.borderWidth = 0.5;
    self.DuiHuan.layer.borderColor = [UIColor colorWithRed:250/255.0 green:170/255.0 blue:28/255.0 alpha:1.0].CGColor;
    self.ChongzhiBtn.layer.borderWidth = 0.5;
    self.ChongzhiBtn.layer.borderColor = [UIColor colorWithRed:250/255.0 green:170/255.0 blue:28/255.0 alpha:1.0].CGColor;
    self.JInBiChongZhi.layer.borderWidth = 0.5;
    self.JInBiChongZhi.layer.borderColor = [UIColor colorWithRed:250/255.0 green:170/255.0 blue:28/255.0 alpha:1.0].CGColor;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    //请求个人信息
    [BackgroundService requestPushVC:self MyselfAction:^{
        [weakSelf HiddenNodataView];
        weakSelf.point.text =[NSString stringWithFormat:@"%@" ,[AuthenticationModel getscore]];
        weakSelf.duifuGold.text = [NSString stringWithFormat:@"%.2f",[[AuthenticationModel getvirtual_glod]floatValue]];
        weakSelf.duifubao.text = [NSString stringWithFormat:@"%.2f",[[AuthenticationModel getcash]floatValue]];
        weakSelf.negativeEquity.text = @"0";
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 积分
- (IBAction)JifenMIngXiAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {    ScoreRecordController * VC = [[ScoreRecordController alloc]initWithNibName:@"ScoreRecordController" bundle:nil];
        VC.scoreAll = [[AuthenticationModel getscore]intValue];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }
    

    
    
}

- (IBAction)DuiHuanAction:(UIButton *)sender {
    ScoreExchangeController *scoreExchangeController = [[ScoreExchangeController alloc] initWithNibName:@"ScoreExchangeController" bundle:nil];
    scoreExchangeController.scoreAll = [[AuthenticationModel getscore] intValue];
    [self.navigationController pushViewController:scoreExchangeController animated:YES];
}

#pragma mark - 对付金币
- (IBAction)DuiFuJInBiAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        MoneyViewController * VC = [[MoneyViewController alloc]initWithNibName:@"MoneyViewController" bundle:nil];
        VC.title = @"兑富金币记录";
        VC.act = @"act=Api/Score/requestVirtualGlodList";
        VC.virtual_glodAndcash = self.personModel.virtual_glod;
        VC.titlelab = @"总兑富金币";
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }

}
#pragma mark - 现金
- (IBAction)MoneyAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        MoneyViewController * VC = [[MoneyViewController alloc]initWithNibName:@"MoneyViewController" bundle:nil];
        VC.act = @"act=Api/Score/requestCashList";
        VC.virtual_glodAndcash = self.personModel.cash;
        VC.titlelab = @"总现金";
        VC.title = @"现金记录";
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }

}
#pragma mark - 金币充值
- (IBAction)JinBiChongZhi:(UIButton *)sender {
    PayViewController * VC = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
    VC.title = @"兑富金币充值";
    [self.navigationController  pushViewController:VC animated:YES];
}

#pragma mark - 现金充值
- (IBAction)ChongZhi:(UIButton *)sender {
    PayViewController * VC = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
    VC.title = @"现金充值";
    [self.navigationController  pushViewController:VC animated:YES];
    
}


#pragma mark - 负资产
- (IBAction)FuZiChang:(UIButton *)sender {
    [self GetPublicController];
    

}
-(void)GetPublicController{
    PublicViewController *PBVC = [[PublicViewController alloc] initWithNibName:@"PublicViewController" bundle:nil];
    [self.navigationController pushViewController:PBVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-- 跳转到登录界面
-(void)pushLoginController{
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    [VC LoginRefreshAction:^{
        
    }];
    [self.navigationController  pushViewController:VC animated:YES];
    
}

@end
