//
//  WithdrawalViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface WithdrawalViewController : BaseViewController
///总余额
@property (weak, nonatomic) IBOutlet UILabel *virtual_glodAndcashLabel;
///兑换比例描述
@property (weak, nonatomic) IBOutlet UILabel *draw_formulaLabel;
///输入现金
@property (weak, nonatomic) IBOutlet UITextField *cashTextfield;
///自动生成
@property (weak, nonatomic) IBOutlet UITextField *automaticTextf;
@property (weak, nonatomic) IBOutlet UILabel *automaticLabel;
///银行卡
@property (weak, nonatomic) IBOutlet UILabel *banklabel;
///属性传值
@property (nonatomic, assign) CGFloat virtual_glodAndcash;

@end
