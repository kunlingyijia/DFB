//
//  MyPropertyViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface MyPropertyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *point;          //积分
@property (weak, nonatomic) IBOutlet UILabel *duifuGold;      //兑富宝
@property (weak, nonatomic) IBOutlet UILabel *duifubao;       //现金
@property (weak, nonatomic) IBOutlet UILabel *negativeEquity; //负资产
///兑换
@property (weak, nonatomic) IBOutlet UIButton *DuiHuan;
///金币充值充值
@property (weak, nonatomic) IBOutlet UIButton *JInBiChongZhi;

//现金充值
@property (weak, nonatomic) IBOutlet UIButton *ChongzhiBtn;

@end
